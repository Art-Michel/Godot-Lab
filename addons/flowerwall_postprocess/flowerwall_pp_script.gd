extends Control

@export var dither: CanvasLayer
@export var preblur_x: CanvasLayer
@export var preblur_y: CanvasLayer
@export var crt: CanvasLayer
@export var bloom: CanvasLayer

@onready var dither_shader: Material = dither.get_child(0).get_material()
@onready var crt_shader: Material= crt.get_child(0).get_material()


func _ready():
	print (crt_shader.get("shader_parameter/noise_strength"))
	print (crt_shader.get("shader_parameter/scanline_opacity"))
	$noise_slider.connect("value_changed", _on_noise_changed)
	$scanlines_slider.connect("value_changed", _on_scanlines_changed)


func _on_noise_changed(value:float) -> void:
	crt_shader.set("shader_parameter/noise_strength", value)
	update_brightness()


func _on_scanlines_changed(value:float) -> void:
	crt_shader.set("shader_parameter/scanline_opacity", value)
	update_brightness()


func update_brightness() -> void:
	var noise_str: float = crt_shader.get("shader_parameter/noise_strength")
	var sc_opacity: float = crt_shader.get("shader_parameter/scanline_opacity")
	
	var value: float = 0.8 + sc_opacity * 0.5 + noise_str / 1.5
	crt_shader.set("shader_parameter/brightness_multiplier", value)
