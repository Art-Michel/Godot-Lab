extends Node

@export var positions: Array[Node3D] = []
@export var camera: Camera3D
var currPos: int
var prevTrans: Transform3D
var targetTrans: Transform3D
var t: float = 0.0
var moving: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		MoveCam(-1)
	if event.is_action_pressed("ui_right"):
		MoveCam(1)

func _ready() -> void:
	prevTrans = positions[0].transform
	targetTrans = positions[0].transform

func _process(delta: float) -> void:
	if moving:
		MovingCam(delta)

func MoveCam(i: int) -> void:
	if(currPos+i > positions.size()-1):
		currPos = 0
	elif currPos+i <0:
		currPos = positions.size()-1
	else:
		currPos = currPos + i
	moving = true
	t = 0
	prevTrans = camera.transform
	targetTrans = positions[currPos].transform

func MovingCam(delta: float) -> void:
	var movement: Vector3 = targetTrans.origin - prevTrans.origin
	t+= delta *4 / movement.length()
	camera.transform = prevTrans.interpolate_with(targetTrans, t)
	if t>= 1:
		moving = false

func _unhandled_key_input(event):
	if event is InputEventKey and !event.is_echo() and event.is_pressed():
		if event.keycode == KEY_F4:
			get_tree().reload_current_scene()
