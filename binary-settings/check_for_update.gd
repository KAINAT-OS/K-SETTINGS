extends Button

var output_array=[]
func _on_pressed():
	var result = OS.execute("/bin/bash",["/usr/share/binary-settings/bash/check_update_.sh"],output_array)
