extends Control

@onready var monitor_dd       : OptionButton = %MonitorDropdown
@onready var resolution_dd    : OptionButton = %ResolutionDropdown

# A list of common resolutions; replace or extend as desired:
var common_res := [
	Vector2i(1920,1080),
	Vector2i(1600,900),
	Vector2i(1280,720),
	Vector2i(1024,768),
]

func _ready() -> void:
	_populate_monitors()
	_populate_resolutions()
	monitor_dd.connect("item_selected", Callable(self, "_apply_settings"))
	resolution_dd.connect("item_selected", Callable(self, "_apply_settings"))

func _populate_monitors() -> void:
	monitor_dd.clear()
	var mc = DisplayServer.get_screen_count()  # number of connected monitors
	for i in mc:
		monitor_dd.add_item("Monitor %d" % i, i)
	monitor_dd.select(0)

func _populate_resolutions() -> void:
	resolution_dd.clear()
	for res in common_res:
		var label = "%dx%d" % [res.x, res.y]
		resolution_dd.add_item(label)
		var index = resolution_dd.get_item_count() - 1
		resolution_dd.set_item_metadata(index, res)
	resolution_dd.select(0)


func _apply_settings(_idx: int) -> void:
	var monitor_index = monitor_dd.get_item_metadata(monitor_dd.get_selected())
	if monitor_index == null:
		monitor_index = 0  # Default to the primary screen if no selection is made

	var res = resolution_dd.get_item_metadata(resolution_dd.get_selected())
	if res == null:
		res = Vector2i(1280, 720)  # Default resolution


	# Move window to chosen monitor
	DisplayServer.window_set_current_screen(monitor_index)

	# Resize the window to the chosen resolution
	DisplayServer.window_set_size(res)

	# Change window mode

	# Apply settings using xrandr
	var monitor_name = "HDMI-1"  # Replace with the actual monitor name
	var mode_str = "%dx%d" % [res.x, res.y]
	var cmd_args = ["--output", monitor_name, "--mode", mode_str]

	var exit_code = OS.execute("xrandr", cmd_args,[])
	if exit_code != 0:
		push_error("Failed to apply display settings.")
	else:
		print("Display settings applied successfully.")
