extends CheckBox


	
func _ready() -> void:
	var on=[]
	OS.execute("bash",["-c","cat ~/.config/kdeglobals | grep SingleClick"],on)
	on = on[0].split("=")[1]
	print(on)
	if "true" in on:
		%CheckBox.button_pressed = true
	else:
		%CheckBox.button_pressed = false


func _on_toggled(toggled_on: bool) -> void:
	# 1) Convert the bool into "true" or "false" using GDScript's inline if-else
	var value_str := "true" if toggled_on else "false"  # :contentReference[oaicite:0]{index=0}
	print(value_str)
	# 2) Build and execute the kwriteconfig5 command in one shot
	var write_cmd := "kwriteconfig5 --file ~/.config/kdeglobals --group KDE --key SingleClick " + value_str
	
	OS.execute("bash", ["-c", write_cmd],[],false)   
	OS.execute("bash",["-c","killall plasmashell"])       # :contentReference[oaicite:1]{index=1}
	OS.execute("bash",["-c", "nohup kstart5 plasmashell >/dev/null 2>&1 &"])  # :contentReference[oaicite:2]{index=2}
	# 3) Restart Plasma so the new setting takes effect immediately
	#var restart_cmd := "plasmashell --replace"
	
