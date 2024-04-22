extends Control

@export var dither: CanvasLayer
@export var preblur_x: CanvasLayer
@export var preblur_y: CanvasLayer
@export var crt: CanvasLayer
@export var bloom: CanvasLayer

@onready var dither_shader: Material = dither.get_child(0).get_material()
@onready var crt_shader: Material= crt.get_child(0).get_material()
@onready var preblur_x_shader: Material= preblur_x.get_child(0).get_material()
@onready var preblur_y_shader: Material= preblur_y.get_child(0).get_material()


func _ready():
	$crt_toggle.connect("toggled", _on_crt_toggled)
	$blur_slider.connect("value_changed", _on_preblur_changed)
	$dithering_toggle.connect("toggled", _on_dithering_toggled)
	$noise_slider.connect("value_changed", _on_noise_changed)
	$scanlines_slider.connect("value_changed", _on_scanlines_changed)
	$downscale_slider.connect("value_changed", _on_downscale_changed)
	$curvature_slider.connect("value_changed", _on_curvature_changed)
	$brightness_slider.connect("value_changed", _on_brightness_changed)


func _on_crt_toggled(value:bool) -> void:
	crt.visible = value
	bloom.visible = value

func _on_preblur_changed(value:float) -> void:
	preblur_x_shader.set("shader_parameter/radius", value)
	preblur_y_shader.set("shader_parameter/radius", value)
	if value > 0:
		preblur_x.visible = true
		preblur_y.visible = true
	else: 
		preblur_x.visible = false
		preblur_y.visible = false

func _on_dithering_toggled(value:bool) -> void:
	dither_shader.set("shader_parameter/dithering", value)
	var coldep: float
	if value: coldep = 4
	else: coldep = 8
	dither_shader.set("shader_parameter/color_depth", coldep)


func _on_downscale_changed(value:float) -> void:
	dither_shader.set("shader_parameter/resolution_scale", value)
	get_window().scaling_3d_scale = 1/value


func _on_noise_changed(value:float) -> void:
	crt_shader.set("shader_parameter/noise_strength", value)
	#update_brightness()


func _on_scanlines_changed(value:float) -> void:
	crt_shader.set("shader_parameter/scanline_opacity", value)
	#update_brightness()


func _on_brightness_changed(value:float) -> void:
	crt_shader.set("shader_parameter/brightness_multiplier", value)


func update_brightness() -> void:
	var noise_str: float = crt_shader.get("shader_parameter/noise_strength")
	var sc_opacity: float = crt_shader.get("shader_parameter/scanline_opacity")
	
	var value: float = 0.8 + sc_opacity * 0.5 + noise_str / 1.5
	crt_shader.set("shader_parameter/brightness_multiplier", value)


func _on_curvature_changed(value: float) -> void:
	crt_shader.set("shader_parameter/curve_power", value)
