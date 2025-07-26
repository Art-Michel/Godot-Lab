extends Node2D

@export_group("References")
@export var stick_sprite: Sprite2D
@export var stick_bg: Sprite2D
@export var dpad: Sprite2D
@export var stick_sprite_tex: Texture2D
@export var notched_stick_tex: Texture2D
@export var dpad_up: Sprite2D
@export var dpad_down: Sprite2D
@export var dpad_left: Sprite2D
@export var dpad_right: Sprite2D

@export_group("Properties")
enum TYPE{Stick, Notched_Stick, DPad}
@export var type: TYPE
@export var stuck_after_spawn: bool = false
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
var stick_pos: Vector2
var relation: Vector2

func _ready():
	initiate_stick()
	despawn()

func _process(delta):
	input()

func initiate_stick():
	stick_bg.visible = false
	stick_range *= scale.x
	if type == TYPE.DPad:
		dpad.visible = true
		stick_sprite.visible = false
		stick_bg.visible = false
	elif type == TYPE.Stick:
		dpad.visible = false
		stick_sprite.visible = true
		stick_bg.visible = true
		stick_bg.texture = stick_sprite_tex
	elif type == TYPE.Notched_Stick:
		dpad.visible = false
		stick_sprite.visible = true
		stick_bg.visible = false
		stick_bg.texture = notched_stick_tex

func input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !stick_bg.visible and !dpad.visible:
			spawn()
		else:
			move()
	else:
		if stick_bg.visible or dpad.visible:
			despawn()

func spawn():
	stick_pos = get_global_mouse_position()
	finger = get_global_mouse_position()
	dpad.global_position = stick_pos
	stick_bg.global_position = stick_pos
	stick_sprite.global_position = finger
	if type == TYPE.Stick or type == TYPE.Notched_Stick and !stick_bg.visible:
		stick_bg.visible = true
		stick_sprite.visible = true
	elif type == TYPE.DPad:
		dpad.visible = true
		update_dpad_visuals()

func despawn():
	passed_center = false
	stick_sprite.position = Vector2.ZERO
	stick_bg.position = Vector2.ZERO
	dpad.position = Vector2.ZERO
	Input.vibrate_handheld(1, rumble_strength /2)
	
	if type == TYPE.Stick or type == TYPE.Notched_Stick:
		stick_bg.visible = false
		stick_sprite.visible = false
	elif type == TYPE.DPad:
		dpad.visible = false
		update_dpad_visuals()

func move():
	finger = get_global_mouse_position()
	relation = finger - stick_pos
	
	if type == TYPE.DPad:
		update_dpad_visuals()
	elif type == TYPE.Stick or type == TYPE.Notched_Stick:
		update_stick_visuals()
	rumble()

func update_stick_visuals():
	stick_sprite.global_position = finger
	if relation.length() > stick_range:
		if stuck_after_spawn:
			stick_sprite.global_position -= relation.normalized() * (relation.length() - stick_range - 1)
			if type == TYPE.Notched_Stick:
				var i: float = round_to_diagonals(relation.angle())
				var j: float = abs(angle_difference(i, relation.angle()))
				stick_sprite.global_position -= relation.normalized() * j * stick_range * 0.1
		else:
			stick_pos += relation.normalized() * (relation.length() - stick_range -1)
			if type == TYPE.Notched_Stick:
				var i: float = round_to_diagonals(relation.angle())
				var j: float = abs(angle_difference(i, relation.angle()))
				stick_bg.global_position = stick_pos + relation.normalized() * j * stick_range * 0.1
			else:
				stick_bg.global_position = stick_pos
			

func update_dpad_visuals():
	if relation.length() > stick_range:
		if !stuck_after_spawn:
			stick_pos += relation.normalized() * (relation.length() - stick_range -1)
		dpad.global_position = stick_pos

	#dpad directions
	var rumbled = true
	if relation.length() < stick_range * 0.25:
		dpad_up.visible = false
		dpad_down.visible = false
		dpad_right.visible = false
		dpad_left.visible = false
		return
	var right_normal = relation.normalized().dot(Vector2(1,0))
	var up_normal = relation.normalized().dot(Vector2(0,-1))
	
	if up_normal > 0.5:
		cardinal_dpad_rumble(dpad_up, false)
		dpad_up.visible = true
	else:
		cardinal_dpad_rumble(dpad_up, true)
		dpad_up.visible = false
		
	if up_normal < -0.5:
		cardinal_dpad_rumble(dpad_down, false)
		dpad_down.visible = true
	else:
		cardinal_dpad_rumble(dpad_down, true)
		dpad_down.visible = false
	
	if right_normal < -0.5:
		cardinal_dpad_rumble(dpad_left, false)
		dpad_left.visible = true
	else:
		cardinal_dpad_rumble(dpad_left, true)
		dpad_left.visible = false
		
	if right_normal > 0.5:
		cardinal_dpad_rumble(dpad_right, false)
		dpad_right.visible = true
	else:
		cardinal_dpad_rumble(dpad_right, true)
		dpad_right.visible = false

func round_to_diagonals(number: float) -> float:
	number = round(number*100)
	var increment = round(PI/4*100)
	return (round(number / increment ) * increment) /100

func rumble():
	if enable_edge_rumbling:
		edge_rumble()
	if enable_cardinal_rumbling:
		if type == TYPE.Stick or type== TYPE.Notched_Stick:
			cardinal_rumble()
	if enable_center_rumbling:
		center_rumble()

func edge_rumble():
	var rumble_range: float
	if type == TYPE.DPad:
		rumble_range = stick_range * 0.25
	else:
		rumble_range = stick_range * 0.9
	if relation.length() >= rumble_range:
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

func cardinal_dpad_rumble(dir: Sprite2D, visible: bool):
	if dir.visible == visible:
		print("wahoo")
		Input.vibrate_handheld(1, rumble_strength)

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
