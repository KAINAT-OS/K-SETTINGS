extends Node

var mouse_device_id = null

func _ready():
	# Detect mouse device ID
	mouse_device_id = get_mouse_device_id()
	if mouse_device_id == null:
		print("Mouse device not found.")
	else:
		print("Mouse device ID: ", mouse_device_id)
	
	# Connect the slider's value_changed signal
	var slider = $HSlider
	slider.connect("value_changed", Callable(self, "_on_slider_value_changed"))

func _input(event):
	if event is InputEventMouseMotion:
		# Handle mouse motion if needed
		pass

func _on_slider_value_changed(value):
	if mouse_device_id != null:
		# Map slider value (e.g., 0 to 100) to acceleration speed (-1 to 1)
		var accel_speed = (value / 50.0) - 1.0
		# Execute the xinput command to set pointer speed
		var command = "xinput --set-prop " + str(mouse_device_id) + " 'libinput Accel Speed' " + str(accel_speed)
		OS.execute("bash", ["-c", command], [])

func get_mouse_device_id():
	var output = []
	var error = []
	var exit_code = OS.execute("bash", ["-c", "xinput list --id-only 'pointer:'"], output)
	if exit_code == 0 and output.size() > 0:
		return output[0].strip_edges()
	return null
