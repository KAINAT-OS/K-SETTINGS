extends Panel
var following= false
var dragging_start_position:Vector2i=Vector2i()

func _on_cross_pressed() -> void:
	get_tree().quit() # Replace with function body.
	


func _on_minimize_pressed() -> void:
	get_tree().root.mode = Window.MODE_MINIMIZED # Replace with function body.





func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following=!following
			dragging_start_position = DisplayServer.mouse_get_position()

func _process(delta: float) -> void:
	if following:
		get_window().position += DisplayServer.mouse_get_position() - dragging_start_position
