extends Node2D

@export_group("References")
@export var stick_sprite: Sprite2D
@export var stick_bg: Sprite2D
@export var stick_bg_sprite: Texture2D
@export var notched_stick_bg_sprite: Texture2D
@export var dpad_sprite: Texture2D
@export var dpad_pressed_sprite: Texture2D

@export_group("Properties")
@export var stuck_after_spawn: bool = false
@export var notched: bool = true
@export var dpad: bool = false
@export var enable_edge_rumbling: bool = true
@export var enable_center_rumbling: bool = true
@export var enable_cardinal_rumbling: bool = true

@export_group("Tweaking")
@export_range(0.0,1,0.1) var rumble_strength: float = 0.5
@export var stick_range: float = 245.0

var edging: bool = false
var passed_cardinal: bool = true
var passed_center: bool = true
var previous_normal: Vector2
var normal: Vector2
var angle : float

var finger: Vector2
var stick: Vector2
var relation: Vector2

func _ready():
	instantiate_stick()
	despawn()

func _process(delta):
	input()

func instantiate_stick():
	stick_bg.visible = false
	stick_range *= scale.x

func input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !stick_bg.visible:
			spawn()
		else:
			move()
	else:
		if stick_bg.visible:
			despawn()

func spawn():
	if !stick_bg.visible:
		stick = get_global_mouse_position()
		finger = get_global_mouse_position()
		stick_bg.global_position = stick
		stick_sprite.global_position = finger
		stick_bg.visible = true
		stick_sprite.visible = true

func despawn():
	stick_bg.visible = false
	stick_sprite.visible = false
	passed_center = false
	stick_sprite.position = Vector2.ZERO
	stick_bg.position = Vector2.ZERO
	Input.vibrate_handheld(1, rumble_strength /2)

func move():
	finger = get_global_mouse_position()
	relation = finger - stick
	
	if dpad:
		update_dpad_visuals()
	else:
		update_stick_visuals()
	rumble()

func update_stick_visuals():
	stick_sprite.global_position = finger
	if relation.length() > stick_range:
		if stuck_after_spawn:
			stick_sprite.global_position -= relation.normalized() * (relation.length() - stick_range - 1)
			if notched:
				var i: float = round_to_diagonals(relation.angle())
				var j: float = abs(angle_difference(i, relation.angle()))
				stick_sprite.global_position -= relation.normalized() * j * stick_range * 0.1
		else:
			stick += relation.normalized() * (relation.length() - stick_range -1)
			if notched:
				var i: float = round_to_diagonals(relation.angle())
				var j: float = abs(angle_difference(i, relation.angle()))
				stick_bg.global_position = stick + relation.normalized() * j * stick_range * 0.1
			else:
				stick_bg.global_position = stick
			

func update_dpad_visuals():
	return

func round_to_diagonals(number: float) -> float:
	number = round(number*100)
	var increment = round(PI/4*100)
	return (round(number / increment ) * increment) /100

func rumble():
	if enable_edge_rumbling:
		edge_rumble()
	if enable_cardinal_rumbling:
		cardinal_rumble()
	if enable_center_rumbling:
		center_rumble()

func edge_rumble():
	if relation.length() >= stick_range * 0.9:
		if !edging:
			Input.vibrate_handheld(1, rumble_strength)
			edging = true
			if enable_cardinal_rumbling:
				angle = round_to_diagonals(relation.angle())
	else:
		edging = false

func cardinal_rumble():
	if edging:
		if abs(angle_difference(angle, relation.angle())) > PI/6:
			Input.vibrate_handheld(1, rumble_strength)
			angle = round_to_diagonals(relation.angle())

func center_rumble():
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
