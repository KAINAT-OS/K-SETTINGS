extends Panel


func _on_cross_pressed() -> void:
	get_tree().quit() # Replace with function body.
	


func _on_minimize_pressed() -> void:
	get_tree().root.mode = Window.MODE_MINIMIZED # Replace with function body.
