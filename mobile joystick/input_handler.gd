extends Node2D

@export_group("References")
@export var stick_button: Sprite2D
@export var stick: Sprite2D

@export_group("Properties")
@export var notched: bool = true
@export var dpad: bool = false
@export var enable_edge_rumbling: bool = true
@export var enable_center_rumbling: bool = true
@export var enable_cardinal_rumbling: bool = true

@export_group("Tweaking")
@export_range(0.0,1,0.1) var rumble_strength: float = 0.5
@export var stick_range: float = 220.0

var edging: bool = false
var passed_cardinal: bool = true
var passed_center: bool = true
var previous_normal: Vector2
var normal: Vector2
var angle : float

func _ready():
	instantiate_stick()
	despawn()

func _process(delta):
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
	passed_center = false
	stick_button.position = Vector2.ZERO
	stick.position = Vector2.ZERO
	Input.vibrate_handheld(1, rumble_strength /2)

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
	rumble(relation)

func round_to_diagonals(number: float, increment: float):
	number = round(number*100)
	increment = round(increment*100)
	return (round(number / increment ) * increment) /100

func rumble(relation: Vector2):
	if enable_edge_rumbling:
		edge_rumble(relation)
	if enable_cardinal_rumbling:
		cardinal_rumble(relation)
	if enable_center_rumbling:
		center_rumble(relation)

func edge_rumble(relation: Vector2):
	if relation.length() >= stick_range * 0.9:
		if !edging:
			Input.vibrate_handheld(1, rumble_strength)
			edging = true
			if enable_cardinal_rumbling:
				angle = round_to_diagonals(relation.angle(), PI/4)
	else:
		edging = false

func cardinal_rumble(relation: Vector2):
	if edging:
		if abs(angle_difference(angle, relation.angle())) > PI/6:
			Input.vibrate_handheld(1, rumble_strength)
			angle = round_to_diagonals(relation.angle(), PI/4)

func center_rumble(relation: Vector2):
	previous_normal = normal
	normal = relation.normalized()
	if relation.length() <= stick_range * 0.2:
		if !passed_center: #checks if you are in the center
			Input.vibrate_handheld(1, rumble_strength/2)
			passed_center = true
	else: # try again by comparing dot products of input direction (in case too fast)
		if previous_normal.dot(normal) < 0 and !passed_center:
			Input.vibrate_handheld(1, rumble_strength/2)
		passed_center = false
