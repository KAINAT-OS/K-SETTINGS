extends Button


func _on_pressed() -> void:
	OS.execute("kcmshell5",["kcm_componentchooser"])
	
	
