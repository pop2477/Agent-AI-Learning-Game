extends Sprite


const evaluated = {
	FALSE = 0,
	NOT_EVALUATED = -1,
	TRUE = 1
}

export(int) var curr = evaluated.NOT_EVALUATED
var selected = false

var draw_to = null
var clicked1 = false
var clicked2 = false
signal connect_parent()
signal connect_child()

func _ready():
	$Light2.visible = false
	$Light1.visible = false

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
	if selected:
		self.global_position = lerp(self.global_position, get_global_mouse_position(), 25 * delta)
	if self.global_position.x > 410:
		self.global_position.x = 410 - self.texture.get_width()/2

func _on_connect(can, to):
	pass

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


func _on_ConnectChild_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		clicked2 = true
		emit_signal("connect_child")


func _on_ConnectChild_mouse_entered():
	$Light2.visible = true


func _on_ConnectChild_mouse_exited():
	$Light2.visible = false
