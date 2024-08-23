extends Node
@export var i : float = 10000.0

func _process(delta: float) -> void:
	i -= delta
	print(delta)
	if i <= 0:
		i = 2
		print("over")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		freezer.new(0.0001, 2.0)
	if event.is_action_pressed("ui_cancel"):
		freezer.new(0.5, 2.0)
