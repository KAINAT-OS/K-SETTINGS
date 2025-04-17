extends Button

func  _on_pressed():
	var output_array = []
	var result = OS.execute("/bin/bash",["/usr/share/binary-settings/bash/remove_all_panels.sh"],output_array)
	var result2= OS.execute("/bin/bash",["/usr/share/binary-settings/bash/KOS-dos11-layout.sh"],output_array)	
