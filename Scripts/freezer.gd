class_name freezer extends Node

var _t_max : float
var _t : float
var _speed : float
@export var curve : Curve

func _init(speed: float, duration: float):
	_t_max = duration
	_speed = speed
	Engine.time_scale = _speed
	#set up Curve
	curve = Curve.new()
	curve.add_point(Vector2(0,_speed))
	curve.add_point(Vector2(0.8,_speed))
	curve.add_point(Vector2(1,1),10)
	curve.bake()

func _process(delta: float) -> void:
	delta /= Engine.time_scale
	update_freeze(delta)

func update_freeze(delta: float) -> void:
	_t += delta
	Engine.time_scale = curve.sample(_t)
	if _t > _t_max:
		Engine.time_scale = 1.0
		get_parent().remove_child(self)
