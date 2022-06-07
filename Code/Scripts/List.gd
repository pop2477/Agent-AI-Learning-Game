extends Sprite

const evaluated = {
	FALSE = 0,
	NOT_EVALUATED = -1,
	TRUE = 1
}

export(int) var curr = evaluated.NOT_EVALUATED
var selected = false
var draw = false

var draw_to = null
var clicked = false
signal connect_parent()

func _ready():
	$Light2D.visible = false

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
	
	if clicked:
		$Light2D.visible = true
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
			if clicked:
				$Light2D.visible = false
				clicked = false


func _on_Drag_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true

func _on_ConnectParent_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		clicked = true
		emit_signal("connect_parent")

func _on_ConnectParent_mouse_entered():
	$Light2D.visible = true

func _on_ConnectParent_mouse_exited():
	$Light2D.visible = false
