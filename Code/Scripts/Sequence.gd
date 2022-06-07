extends Sprite

const evaluated = {
	FALSE = 0,
	NOT_EVALUATED = -1,
	TRUE = 1
}

export(int) var curr = evaluated.NOT_EVALUATED
var selected = false
var clicked1 = false
var clicked2 = false
var clicked3 = false
var clicked4 = false
var clicked5 = false

signal connect_parent()
signal connect_child1()
signal connect_child2()
signal connect_child3()
signal connect_child4()

func _ready():
	$Light1.visible = false
	$Light2.visible = false
	$Light3.visible = false
	$Light4.visible = false
	$Light5.visible = false


func _physics_process(delta):
	if curr < 0:
		$NotEvaluated.visible = true
		$True.visible = false
		$False.visible = false
	elif curr > 0:
		$NotEvaluated.visible = false
		$True.visible = true
		$False.visible = false
	elif curr == 0:
		$NotEvaluated.visible = false
		$True.visible = false
		$False.visible = true
	
	if clicked1:
		$Light1.visible = true
	if clicked2:
		$Light2.visible = true
	if clicked3:
		$Light3.visible = true
	if clicked4:
		$Light4.visible = true
	if clicked5:
		$Light5.visible = true
	if selected:
		self.global_position = lerp(self.global_position, get_global_mouse_position(), 25 * delta)
	if self.global_position.x > 410:
		self.global_position.x = 410 - self.texture.get_width()/2


func _on_evaluation(eval):
	if eval:
		curr = evaluated.TRUE
	else:
		curr = evaluated.FALSE

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
		elif event.button_index == BUTTON_LEFT and event.pressed:
			if clicked1:
				$Light1.visible = false
				clicked1 = false
			if clicked2:
				$Light2.visible = false
				clicked2 = false
			if clicked3:
				$Light3.visible = false
				clicked3 = false
			if clicked4:
				$Light4.visible = false
				clicked4 = false
			if clicked5:
				$Light5.visible = false
				clicked5 = false


func _on_Drag_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true


func _on_ConnectParent_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		clicked1 = true
		emit_signal("connect_parent")


func _on_ConnectParent_mouse_entered():
	$Light1.visible = true


func _on_ConnectParent_mouse_exited():
	$Light1.visible = false


func _on_ConnectChild1_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		clicked2 = true
		emit_signal("connect_child1")


func _on_ConnectChild1_mouse_entered():
	$Light2.visible = true


func _on_ConnectChild1_mouse_exited():
	$Light2.visible = false


func _on_ConnectChild2_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		clicked3 = true
		emit_signal("connect_child2")


func _on_ConnectChild2_mouse_entered():
	$Light3.visible = true


func _on_ConnectChild2_mouse_exited():
	$Light3.visible = false


func _on_ConnectChild3_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		clicked4 = true
		emit_signal("connect_child3")


func _on_ConnectChild3_mouse_entered():
	$Light4.visible = true


func _on_ConnectChild3_mouse_exited():
	$Light4.visible = false


func _on_ConnectChild4_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		clicked5 = true
		emit_signal("connect_child4")


func _on_ConnectChild4_mouse_entered():
	$Light5.visible = true


func _on_ConnectChild4_mouse_exited():
	$Light5.visible = false
