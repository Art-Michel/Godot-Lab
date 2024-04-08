@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("crt_autload", "crt.gd")
	pass


func _exit_tree():
	remove_autoload_singleton("crt_autload")
	pass
