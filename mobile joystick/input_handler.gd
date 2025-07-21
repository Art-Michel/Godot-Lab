extends Node2D

@export_range(0.0,1,0.1) var rumble_strength: float = 0.5
@export var stick_button: Sprite2D
@export var stick: Sprite2D
@export var stick_range: float = 220.0

var has_reached_edge: bool = false
var has_passed_center: bool = false
var angle : float

func _ready():
	instantiate_stick()
	despawn()

func _physics_process(delta):
	input()

func instantiate_stick():
	stick.visible = false
	stick_range *= scale.x

func input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !stick.visible:
			spawn()
		else:
			move()
	else:
		if stick.visible:
			despawn()

func despawn():
	stick.visible = false
	stick_button.visible = false
	has_passed_center = false
	stick_button.position = Vector2.ZERO
	stick.position = Vector2.ZERO
	Input.vibrate_handheld(1, rumble_strength)

func spawn():
	if !stick.visible:
			stick.global_position = get_global_mouse_position()
			stick_button.global_position = get_global_mouse_position()
			stick.visible = true
			stick_button.visible = true

func move():
	stick_button.global_position = get_global_mouse_position()
	var relation := stick_button.global_position - stick.global_position
	if relation.length() > stick_range:
		stick.global_position += relation.normalized() * (relation.length() - stick_range -1)
	vibrate(relation)

func round_to_diagonals(number: float, increment: float):
	number = round(number*100)
	increment = round(increment*100)
	return (round(number / increment ) * increment) /100

func vibrate(relation: Vector2):
	if relation.length() >= stick_range * 0.9:
		if !has_reached_edge:
			Input.vibrate_handheld(1, rumble_strength)
			has_reached_edge = true
			angle = round_to_diagonals(relation.angle(), PI/4)
		else:
			if abs(angle_difference(angle, relation.angle())) > PI/5:
				has_reached_edge = false
	else:
		has_reached_edge = false
	if relation.length() <= stick_range * 0.25:
		if !has_passed_center:
			Input.vibrate_handheld(1, rumble_strength/2)
			has_passed_center = true
	else:
		has_passed_center = false
