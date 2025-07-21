extends CanvasLayer

@export var rgb_diff_shader: ShaderMaterial

var red: bool = 1.0
var green: bool = 1.0
var blue: bool = 1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("r"):
		red = !red
		rgb_diff_shader.set("shader_parameter/r",red)
	if event.is_action_pressed("g"):
		green = !green
		rgb_diff_shader.set("shader_parameter/g", green)
	if event.is_action_pressed("b"):
		blue = !blue
		rgb_diff_shader.set("shader_parameter/b", blue)
