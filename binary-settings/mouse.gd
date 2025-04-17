extends Button

var output_array := PackedStringArray()  # Create a PackedStringArray variable

func _on_pressed():
	OS.execute("systemsettings5",["kcm_mouse"], output_array)  # Pass the PackedStringArray variable as the second argument
	# No need to return anything from the _on_pressed function
