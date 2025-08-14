extends Button


func _on_pressed() -> void:
	OS.create_process("kcmshell5",["kcm_componentchooser"])
	
