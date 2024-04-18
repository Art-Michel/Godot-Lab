extends Control

var crt_pp_packed: PackedScene = preload("res://addons/flowerwall_crt_shader/flowerwall_crt_postprocess.tscn")
var crt_pp: Control
var crt_shader: Material

func _ready() -> void:
	create_crt_pp()
	enable_crt()

func create_crt_pp() -> void:
	crt_pp = crt_pp_packed.instantiate()
	add_child(crt_pp)
	crt_shader = crt_pp.get_node("CRT/crt_shader").get_material()

func _unhandled_key_input(event):
	if event is InputEventKey and !event.is_echo() and event.is_pressed():
		if event.keycode == KEY_F3:
			enable_crt()
		if event.keycode == KEY_F2:
			change_value("noise_strength", 1.0)

func enable_crt() -> void:
	if get_node_or_null("crt_pp"):
		print("Toggled CRT Filter")
		if crt_pp.visible:
			for node in crt_pp.get_children():
				node.visible = false
			crt_pp.visible = false
		else:
			for node in crt_pp.get_children():
				node.visible = true
			crt_pp.visible = true
	else:
		print ("Could not find CRT Filter node, creating one") 
		create_crt_pp()

func enable_preblur() -> void:
	if get_node_or_null("crt_pp"):
		pass

func change_value(variable: String, value: float) -> void:
	if get_node_or_null("crt_pp"):
		crt_shader.set(variable, value)
	
	else:
		print ("Could not find CRT Filter node, creating one") 
		create_crt_pp()
		change_value(variable, value)