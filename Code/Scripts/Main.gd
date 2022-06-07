extends Node2D


var node_connectors = {
	ROOT_C1 = 0,
	ROOT_C2 = 1,
	HRHP = 2,
	HNGP = 3,
	HOSP = 4,
	SP = 5,
	SC1 = 6,
	SC2 = 7,
	SC3 = 8,
	SC4 = 9,
	INVP = 10,
	INVC = 11,
	AP = 12,
	LP = 13
}

var parents_connectors = [node_connectors.HRHP, node_connectors.HNGP, node_connectors.HOSP, node_connectors.SP, node_connectors.INVP, node_connectors.AP, node_connectors.LP]
var child_connectors = [node_connectors.ROOT_C1, node_connectors.ROOT_C2, node_connectors.SC1, node_connectors.SC2, node_connectors.SC3, node_connectors.SC4, node_connectors.INVC]

var has_children = [node_connectors.SP, node_connectors.INVP]


var initial_pos = Vector2(12, 82) * 6
var suspect_pos = [Vector2(50, 82) * 6, Vector2(16, 52) * 6, Vector2(45, 35) * 6, Vector2(75, 40) * 6]
# red hat, no glasses, orange shirt
var suspect_desc = [[false, false, true], [true, true, true], [true, false, false], [true, false, true]]
var curr_suspect = 0

var from_c = []
var to_c = []
var tree = [[-1, -1],[-1, -1, -1, -1],[-1]]
	



func _ready():
	$GameScreen/Agent.global_position = initial_pos + $GameScreen.rect_global_position
	$CanvasLayer/CompletedLabel.visible = false
	$CanvasLayer/FailLabel.visible = false

func _physics_process(delta):
	checkConnection()
	update()


func hasRedHat():
	for i in suspect_pos.size():
		if $GameScreen/Agent.global_position == suspect_pos[i] + $GameScreen.rect_global_position:
			return suspect_desc[i][0]

func hasNoGlasses():
	for i in suspect_pos.size():
		if $GameScreen/Agent.global_position == suspect_pos[i] + $GameScreen.rect_global_position:
			return suspect_desc[i][1]

func hasOrangeShirt():
	for i in suspect_pos.size():
		if $GameScreen/Agent.global_position == suspect_pos[i] + $GameScreen.rect_global_position:
			return suspect_desc[i][2]


func arrest():
	if tree[1].has(2) and tree[1].has(10) and tree[1].has(4) and tree[2] == [3] and (tree[1].has(13) or tree[0].has(13)):
		$CanvasLayer/CompletedLabel.visible = true
		$FailTimer.start()
		return true
	elif curr_suspect < suspect_pos.size():
		return false
	else:
		$CanvasLayer/FailLabel.visible = true
		$FailTimer.start()

func list():
	if curr_suspect >= suspect_pos.size():
		$CanvasLayer/FailLabel.visible = true
		$FailTimer.start()
		return false
	else:
		$GameScreen/Agent.global_position = suspect_pos[curr_suspect] + $GameScreen.rect_global_position
		curr_suspect += 1
		return true
		
func sequence():
	return eval(1)

func inverse():
	return !eval(2)

func eval(node):
	var cond = true
	var i = 0
	while cond and i < tree[node].size():
		if tree[node][i] == node_connectors.HRHP:
			cond = hasRedHat()
			if cond:
				$HasRedHat.curr = 1
			else:
				$HasRedHat.curr = 0
		elif tree[node][i] == node_connectors.HNGP:
			cond = hasNoGlasses()
			if cond:
				$HasNoGlasses.curr = 1
			else:
				$HasNoGlasses.curr = 0
		elif tree[node][i] == node_connectors.HOSP:
			cond = hasOrangeShirt()
			if cond:
				$HasOrangeShirt.curr = 1
			else:
				$HasOrangeShirt.curr = 0
		elif tree[node][i] == node_connectors.LP:
			cond = list()
			if cond:
				$List.curr = 1
			else:
				$List.curr = 0
		elif tree[node][i] == node_connectors.SP:
			cond = sequence()
			if cond:
				$SequenceNode.curr = 1
			else:
				$SequenceNode.curr = 0
		elif tree[node][i] == node_connectors.INVP:
			cond = inverse()
			if cond:
				$Inverse.curr = 1
			else:
				$Inverse.curr = 0
		elif tree[node][i] == node_connectors.AP:
			cond = arrest()
			if cond:
				$Arrest.curr = 1
			else:
				$Arrest.curr = 0
		i += 1
	return cond


func construct_tree():
	for i in from_c.size():
		if to_c[i] == node_connectors.ROOT_C1:
			tree[0][0] = from_c[i]
	#		tree.append([node_connectors.ROOT_C1, from_c[i]])
		elif to_c[i] == node_connectors.ROOT_C2:
			tree[0][1] = from_c[i]
	#		tree.append([node_connectors.ROOT_C2, from_c[i]])
		elif to_c[i] == node_connectors.SC1:
			tree[1][0] = from_c[i]
	#		tree.append([node_connectors.SC1, from_c[i]])
		elif to_c[i] == node_connectors.SC2:
			tree[1][1] = from_c[i]
	#		tree.append([node_connectors.SC2, from_c[i]])
		elif to_c[i] == node_connectors.SC3:
			tree[1][2] = from_c[i]
	#		tree.append([node_connectors.SC3, from_c[i]])
		elif to_c[i] == node_connectors.SC4:
			tree[1][3] = from_c[i]
	#		tree.append([node_connectors.SC4, from_c[i]])
		elif to_c[i] == node_connectors.INVC:
			tree[2][0] = from_c[i]
	#		tree.append([node_connectors.INVC, from_c[i]])
	print(tree)


func _draw():
	if from_c.size() > to_c.size():
		for i in to_c.size():
			draw_line(get_node_pos(from_c[i]), get_node_pos(to_c[i]), Color(0,0,0,1), 5)
	else:
		for i in from_c.size():
			draw_line(get_node_pos(from_c[i]), get_node_pos(to_c[i]), Color(0,0,0,1), 5)


func checkConnection():
	if !from_c.empty():
		if from_c.size() > to_c.size():
			if from_c.find(from_c.back()) != from_c.find_last(from_c.back()):
				from_c.pop_back()
			elif to_c.find(from_c.back()) >= 0:
				from_c.pop_back()
		else:
			if to_c.find(to_c.back()) != to_c.find_last(to_c.back()):
				to_c.pop_back()
			elif from_c.find(to_c.back()) >= 0:
				to_c.pop_back()
			elif parents_connectors.find(to_c.back()) >= 0 and parents_connectors.find(from_c.back()) >= 0:
				to_c.pop_back()
			elif child_connectors.find(to_c.back()) >= 0 and child_connectors.find(from_c.back()) >= 0:
				to_c.pop_back()
			elif to_c.back() == node_connectors.AP and from_c.back() == node_connectors.INVC:
				to_c.pop_back()
			elif to_c.back() == node_connectors.INVC and from_c.back() == node_connectors.AP:
				to_c.pop_back()
			elif to_c.back() == node_connectors.LP and from_c.back() == node_connectors.INVC:
				to_c.pop_back()
			elif to_c.back() == node_connectors.INVC and from_c.back() == node_connectors.LP:
				to_c.pop_back()
			elif to_c.back() == node_connectors.LP and !(from_c.back() != node_connectors.ROOT_C1 or from_c.back() != node_connectors.ROOT_C2):
				to_c.pop_back()
			elif !(to_c.back() != node_connectors.ROOT_C1 or to_c.back() != node_connectors.ROOT_C2) and from_c.back() == node_connectors.LP:
				to_c.pop_back()


func get_node_pos(var i):
	if i == 0:
		return $Root/Child1.global_position
	elif i == 1:
		return $Root/Child2.global_position
	elif i == 2:
		return $HasRedHat/ConnectParent.global_position
	elif i == 3:
		return $HasNoGlasses/ConnectParent.global_position
	elif i == 4:
		return $HasOrangeShirt/ConnectParent.global_position
	elif i == 5:
		return $SequenceNode/ConnectParent.global_position
	elif i == 6:
		return $SequenceNode/ConnectChild1.global_position
	elif i == 7:
		return $SequenceNode/ConnectChild2.global_position
	elif i == 8:
		return $SequenceNode/ConnectChild3.global_position
	elif i == 9:
		return $SequenceNode/ConnectChild4.global_position
	elif i == 10:
		return $Inverse/ConnectParent.global_position
	elif i == 11:
		return $Inverse/ConnectChild.global_position
	elif i == 12:
		return $Arrest/ConnectParent.global_position
	elif i == 13:
		return $List/ConnectParent.global_position


func _on_Root_connect_child1(pos):
#	if from_c.size() == to_c.size():
#		from_c.append(node_connectors.ROOT_C1)
#	else: 
	to_c.append(node_connectors.ROOT_C1)

func _on_Root_connect_child2(pos):
#	if from_c.size() == to_c.size():
#		from_c.append(node_connectors.ROOT_C2)
#	else: 
	to_c.append(node_connectors.ROOT_C2)

func _on_HasRedHat_ready_to_connect(pos):
	#if from_c.size() == to_c.size():
	from_c.append(node_connectors.HRHP)
	#else: 
	#	to_c.append(node_connectors.HRHP)

func _on_HasNoGlasses_ready_to_connect(pos):
	#if from_c.size() == to_c.size():
	from_c.append(node_connectors.HNGP)
	#else: 
	#to_c.append(node_connectors.HNGP)

func _on_HasOrangeShirt_ready_to_connect(pos):
#	if from_c.size() == to_c.size():
	from_c.append(node_connectors.HOSP)
#	else: 
#		to_c.append(node_connectors.HOSP)

func _on_SequenceNode_connect_parent():
	from_c.append(node_connectors.SP)

func _on_SequenceNode_connect_child1():
	to_c.append(node_connectors.SC1)

func _on_SequenceNode_connect_child2():
	to_c.append(node_connectors.SC2)

func _on_SequenceNode_connect_child3():
#	else:
	to_c.append(node_connectors.SC3)

func _on_SequenceNode_connect_child4():
	to_c.append(node_connectors.SC4)

func _on_Inverse_connect_parent():
	from_c.append(node_connectors.INVP)

func _on_Inverse_connect_child():
	to_c.append(node_connectors.INVC)

func _on_Arrest_connect_parent():
	from_c.append(node_connectors.AP)

func _on_List_connect_parent():
	from_c.append(node_connectors.LP)


func _on_ReplayB_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			from_c.clear()
			to_c.clear()
			tree.clear()


func _on_PlayB_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			tree = [[-1, -1],[-1, -1, -1, -1],[-1]]
			construct_tree()
			eval(0)
				


func _on_FailTimer_timeout():
	self.get_tree().reload_current_scene()


func _on_Wait_timeout():
	self.get_tree().paused = false
