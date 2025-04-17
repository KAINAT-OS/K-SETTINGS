extends Button


func _on_pressed():
	var output_array := PackedStringArray() 
	OS.execute("killall",["systemsettings"],output_array)
	OS.execute("systemsettings5",output_array)
	return 0
