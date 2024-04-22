extends OptionButton

@export var dither: CheckButton
@export var crt: CheckButton
@export var downscale: HSlider
@export var blur: HSlider
@export var noise: HSlider
@export var scanline: HSlider
@export var curve: HSlider
@export var brightness: HSlider

func _ready() -> void:
	connect("item_selected", _on_preset_selected)

func _on_preset_selected(value:int) -> void:
	match value:
		0: # High Res
			dither.button_pressed = false
			crt.button_pressed = false
			downscale.value = 1
			blur.value = 0
			noise.value = 0
			scanline.value = 0
			curve.value = 0
			brightness.value = 1
		1: # (Dithered, pixelated)
			dither.button_pressed = true
			crt.button_pressed = false
			downscale.value = 6
			blur.value = 0
			noise.value = 0
			scanline.value = 0
			curve.value = 0
			brightness.value = 1
		2: # Sharp CRT (CRT Monitor)
			dither.button_pressed = false
			crt.button_pressed = true
			downscale.value = 1
			blur.value = 1
			noise.value = 0
			scanline.value = 0.7
			curve.value = 0.0
			brightness.value = 1.1
		3: # CRT TV (Blurry, Noisy)
			dither.button_pressed = false
			crt.button_pressed = true
			downscale.value = 1
			blur.value = 3
			noise.value = 0.25
			scanline.value = 0.45
			curve.value = 1.02
			brightness.value = 1.2
