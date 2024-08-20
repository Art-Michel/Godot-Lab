extends Node

@export var t_max := 5.0
var t := 0.0
@export var curve : Curve

func _enter_tree() -> void:
	Engine.time_scale = 0.001
	pass

func _process(delta: float) -> void:
	delta /= Engine.time_scale
	update_freeze(delta)

func update_freeze(delta: float) -> void:
	t += delta
	Engine.time_scale = curve.sample(remap(t, 0, t_max, 0.001, 1))
	if t > t_max:
		print("freeze over")
		Engine.time_scale = 1
		get_parent().remove_child(self)
