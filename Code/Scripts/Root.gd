extends Sprite

signal connect_child1(pos)
signal connect_child2(pos)
var highlight1 = false
var highlight2 = false

func _ready():
	$Light1.visible = false
	$Light2.visible = false


func _physics_process(delta):
	if highlight1:
		$Light1.visible = true
	elif highlight2:
		$Light2.visible = true


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if highlight1:
				$Light2D.visible = false
				highlight1 = false
			elif highlight2:
				$Light2D.visible = false
				highlight2 = false

func _on_Child1_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		var highlight1 = true
		emit_signal("connect_child1", $Child1.global_position)


func _on_Child2_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		var highlight2 = true
		emit_signal("connect_child2", $Child2.global_position)


func _on_Child1_mouse_entered():
	$Light1.visible = true


func _on_Child2_mouse_entered():
	$Light2.visible = true


func _on_Child1_mouse_exited():
	$Light1.visible = false


func _on_Child2_mouse_exited():
	$Light2.visible = false
