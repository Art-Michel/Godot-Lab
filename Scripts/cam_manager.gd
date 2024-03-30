extends Node

@export var positions: Array[Node3D] = []
@export var camera: Camera3D
var previousCamPos: Vector3
var previousCamRot: Quaternion
var targetPos: int = 0
var t: float = 0.0
var moving: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		MoveCamB()
	if event.is_action_pressed("ui_right"):
		MoveCamF()

func _ready() -> void:
	previousCamPos = 0
	targetPos = 0
	camera.position = positions[0].position
	camera.rotation = positions[0].rotation

func _process(delta: float) -> void:
	if moving:
		MovingCam()

func MoveCamF() -> void:
	if(targetPos+1 > positions.size()-1):
		targetPos = 0
	else:
		targetPos += 1
	moving = true
	camera.position = positions[targetPos].position
	camera.rotation = positions[targetPos].rotation

func MovingCam(from: int, to: int) -> void:
	
