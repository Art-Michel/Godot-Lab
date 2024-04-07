extends Control

var crt_pp_packed = preload("res://Scenes/custom_pp.tscn")
var crt_pp: Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enable_crt"):
		enable_crt()

func enable_crt() -> void:
	if !$PostProcess:
		crt_pp = crt_pp_packed.instantiate()
		add_child(crt_pp)

	else:
		if crt_pp.visible:
			crt_pp.get_node("HBlur").visible = false
			crt_pp.get_node("VBlur").visible = false
			crt_pp.get_node("Scanlines").visible = false
			crt_pp.get_node("Grid").visible = false
			crt_pp.get_node("Bloom").visible = false
			crt_pp.visible = false
		else:
			crt_pp.get_node("HBlur").visible = true
			crt_pp.get_node("VBlur").visible = true
			crt_pp.get_node("Scanlines").visible = true
			crt_pp.get_node("Grid").visible = true
			crt_pp.get_node("Bloom").visible = true
			crt_pp.visible = true