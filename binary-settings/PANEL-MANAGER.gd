extends MarginContainer

var panels: Array[PanelContainer]=[]
@onready var display: Button = %display
@onready var input: Button = %input
@onready var apps: Button = %Apps
@onready var update: Button = %Update
@onready var personalization: Button = %personalization
@onready var btn_User: Button = %btn_Users_and_accounts
@onready var button_8: Button = %Button8
@onready var button_9: Button = %Button9
@onready var button_10: Button = %Button10
@onready var color_rect: ColorRect = %ColorRect
@onready var settings_panel: PanelContainer = %settings_panel
@onready var sa_dark: CheckButton = %sa_dark
@onready var labelx: Label = %Labeld
@onready var btn_language_and_locals: Button = %btn_Language_And_Locals
@onready var btn_users: Button = %btn_Users

var darktheme=load("res://dark_theme.tres")
var lighttheme=load("res://light_theme.tres")


func _ready() -> void:
	panels=[%Display, %Inputs, %APPS, %UPDATE, %PERSONALIZATION,%Language_And_Locals,%Network,%About,%User_And_Accounts]
	
	display.pressed.connect(show_panel.bind(panels[0]))
	input.pressed.connect(show_panel.bind(panels[1]))
	apps.pressed.connect(show_panel.bind(panels[2]))
	update.pressed.connect(show_panel.bind(panels[3]))
	personalization.pressed.connect(show_panel.bind(panels[4]))
	btn_language_and_locals.pressed.connect(show_panel.bind(panels[5]))
	button_8.pressed.connect(show_panel.bind(panels[6]))
	button_9.pressed.connect(show_panel.bind(panels[7]))
	show_panel(panels[4])
	sa_dark.connect("toggled", Callable(self,"save_variable"))
	btn_User.pressed.connect(show_panel.bind(panels[8]))
	load_variable()

func show_panel(panel_to_show:PanelContainer) -> void:
	panels=[%Display, %Inputs, %APPS, %UPDATE, %PERSONALIZATION,%Language_And_Locals,%Network,%About,%User_And_Accounts]

	for panel in panels:
		panel.hide()
	panel_to_show.show()
	
func _process(delta):
	get_system_theme()
	
func get_system_theme() -> void:
	var theme_raw :=[]
	OS.execute("kreadconfig5",["--key","LookAndFeelPackage"],theme_raw)
	var theme = theme_raw[0]
	if "light" in theme and  not sa_dark.button_pressed :
		light_theme()
	else:
		dark_theme()
	

	
func light_theme() -> void:
	$"../../..".set_theme(lighttheme)
	%"light-color".show()
	%"dark-color".hide()

func dark_theme() -> void:
	$"../../..".set_theme(darktheme)
	%"light-color".hide()
	%"dark-color".show()



func save_variable():
	var config = ConfigFile.new()
	config.set_value("defaults", "always_dark", sa_dark.button_pressed)
	var error = config.save("user://save_data.cfg")
	if error != OK:
		print("Failed to save config file: ", error)
	print ("saved")
		
		
		
func load_variable():
	var config = ConfigFile.new()
	var error = config.load("user://save_data.cfg")
	if error != OK:
		print("Failed to load config file: ", error)
		return
	var always_dark = config.get_value("default", "always_dark", true)
	print("Loaded:", always_dark)


func open_users() -> void:
	OS.execute("kcmshell5",["kcm_users"])

func connections() -> void:
	OS.execute("kcmshell5",["kcm_users"])


func _on_connections_pressed() -> void:
	OS.execute("kcmshell5",["kcm_networkmanagement"])


func _on_connections_2_pressed() -> void:
	OS.execute("kcmshell5",["proxy"])


func _on_about_text_ready() -> void:
	var about_os = []
	OS.execute("cat",["/usr/lib/os-release"],about_os)
	%about_text.add_text(about_os[0])


func _on_btn_fullabout_pressed() -> void:
	OS.execute("kcmshell5",["kcm_about-distro"])


func _on_button_10_pressed() -> void:
	OS.execute("systemsettings5",[])


func _on_btn_users_pressed() -> void:
	OS.execute("kcmshell5",["kcm_users"])


func _on_btn_accounts_pressed() -> void:
	OS.execute("kcmshell5",["kcm_kaccounts"])


func _on_btn_kde_wallet_pressed() -> void:
	OS.execute("systemsettings",["kcm_kwallet5"])


func _on_shortcuts_pressed() -> void:
	OS.execute("kcmshell5",["kcm_keys"])


func _on_autostart_pressed() -> void:
	OS.execute("kcmshell5",["kcm_autostart"])


func _on_btn_spell_checking_2_pressed() -> void:
	OS.execute("ibus-setup",[])
