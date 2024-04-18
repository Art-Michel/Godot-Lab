@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("flowerwall_crt_autload", "flowerwall_crt_autoload.gd")
	pass


func _exit_tree():
	remove_autoload_singleton("flowerwall_crt_autload")
	pass
