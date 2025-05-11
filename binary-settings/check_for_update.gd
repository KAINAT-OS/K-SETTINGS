extends Button

var output_array=[]
func _on_pressed():
	var result = OS.execute("plasma-discover",["--mode", "Update"],[],true)
