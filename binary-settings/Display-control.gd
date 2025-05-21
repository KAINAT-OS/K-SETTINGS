extends Control

@onready var monitor_dd       : OptionButton = %MonitorDropdown
@onready var resolution_dd    : OptionButton = %ResolutionDropdown
@onready var applyx: Button = %apply
@onready var rt_dropdown: OptionButton = %RT_Dropdown
@onready var h_slider: HSlider = $VBoxContainer/BRIGTHNESS/HSlider

# A list of common resolutions; replace or extend as desired:
var common_res := [
	Vector2i(1920,1080),
	Vector2i(1600,900),
	Vector2i(1280,720),
	Vector2i(1024,768),
]

var common_rate := [30,59,60,75,120,144,165]

func _ready() -> void:
	_populate_monitors()
	_populate_resolutions()
	_populate_refresh_rate()
	_default_resulation_monitor()
	applyx.connect("pressed",Callable(self,"_apply_settings"))
	h_slider.value=load_variable()
	%bdis.text=str(h_slider.value*100)+"%"
	
func _default_resulation_monitor() -> void:
	var primary_screen := DisplayServer.get_primary_screen()
	var screen_size :Vector2i = DisplayServer.screen_get_size(primary_screen)
	var crate := DisplayServer.screen_get_refresh_rate(primary_screen)
	var count=0
	for res in common_res:
		if(res == screen_size):
			resolution_dd.select(count)
		count+=1
		
	var rcount=0
	for rate in common_rate:
		if(rate == crate):
			rt_dropdown.select(rcount)
		rcount +=1

func _populate_monitors() -> void:
	var primary_screen := DisplayServer.get_primary_screen()
	monitor_dd.clear()
	var mc = DisplayServer.get_screen_count()  # number of connected monitors
	for i in mc:
		monitor_dd.add_item("Monitor %d" % i, i)
	monitor_dd.select(primary_screen)

func _populate_resolutions() -> void:
	resolution_dd.clear()
	for res in common_res:
		var label = "%dx%d" % [res.x, res.y]
		resolution_dd.add_item(label)
		var index = resolution_dd.get_item_count() - 1
		resolution_dd.set_item_metadata(index, res)

func _populate_refresh_rate() -> void:
	rt_dropdown.clear
	for rate in common_rate:
		var index = (rt_dropdown.item_count)
		rt_dropdown.add_item(str(rate))
		rt_dropdown.set_item_metadata(index,rate)

func _apply_settings() -> void:
	var monitor_index = monitor_dd.get_item_metadata(monitor_dd.get_selected())
	if monitor_index == null:
		monitor_index = 0  # Default to the primary screen if no selection is made

	var res = resolution_dd.get_item_metadata(resolution_dd.get_selected())
	if res == null:
		res = Vector2i(1280, 720)  # Default resolution
		
	var rate = rt_dropdown.get_item_metadata(rt_dropdown.selected)
	print (rate)
	if rate == null:
		rate = 60
		
	# Move window to chosen monitor
	DisplayServer.window_set_current_screen(monitor_index)

	# Resize the window to the chosen resolution
	#getting the monitor name

	# Change window mode

	# Apply settings using xrandr
	var brightness = h_slider.value
	var monitor_name_raw =[]
	OS.execute("bash",["-c","xrandr | grep 'primary' | cut -d' ' -f1"],monitor_name_raw)
	var monitor_name = monitor_name_raw[0].split("\n")[0]
	print (monitor_name)
  # Replace with the actual monitor name
	var mode_str = "%dx%d" % [res.x, res.y]
	var cmd_args = ["--output", monitor_name, "--mode", mode_str, "--rate", rate, "--brightness", brightness]
	print (cmd_args)
	var exit_code = OS.execute("xrandr", cmd_args,[])
	if exit_code != 0:
		push_error("Failed to apply display settings.")
	else:
		print("Display settings applied successfully.")
	save_variable()
		
func _on_h_slider_value_changed(value: float) -> void:
	_apply_settings()
	%bdis.text=str(h_slider.value*100)+"%"


func save_variable():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")  # Load existing config or create new
	
	# Set the variable value in a section
	config.set_value("settings", "brightness", h_slider.value)
	
	# Save the config file
	err = config.save("user://settings.cfg")
	if err != OK:
		print("Failed to save config file!")
	else:
		print("Config saved successfully.")



func load_variable():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		# Read the value from the section with a default fallback
		var my_var = config.get_value("settings", "brightness", 1)
		print("Loaded variable:", my_var)
		return my_var
	else:
		print("Failed to load config file!")
		return null
