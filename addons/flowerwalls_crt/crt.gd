extends Control

var crt_pp_packed = preload("crt_pp.tscn")
var crt_pp: Control

func _unhandled_key_input(event):
	if event is InputEventKey and !event.is_echo() and event.is_pressed():
		if event.keycode == KEY_F3:
			enable_crt()

func enable_crt() -> void:
	if !$PostProcess:
		crt_pp = crt_pp_packed.instantiate()
		add_child(crt_pp)

	else:
		if crt_pp.visible:
			for node in crt_pp.get_children():
				node.visible = false
			crt_pp.visible = false
		else:
			for node in crt_pp.get_children():
				node.visible = true
			crt_pp.visible = true
