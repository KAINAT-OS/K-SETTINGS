extends Button


func _on_pressed() -> void:
	OS.create_process("kcmshell5",["kcm_keys"]) # Replace with function body.
