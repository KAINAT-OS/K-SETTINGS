extends Control
#themes:
const DARK_THEME = preload("res://dark_theme.tres")
const LIGHT_THEME = preload("res://light_theme.tres")

#Panels:

@onready var tabs: VBoxContainer = %tabs


func _ready():
	# Apply at startup
	_apply_system_theme()
	# Listen for changes
	DisplayServer.set_system_theme_change_callback(_on_system_theme_changed)
	for btn in tabs.get_children():
		if btn is Button:
			print(btn.name)
			btn.pressed.connect(Callable(self,"_change_panel").bind(btn.name))
	var nvidiacheck=OS.execute("bash",["-c","dpkg -s nvidia-driver-kainatos > /dev/null 2>&1"])
	if nvidiacheck == 0:
		%"btn_nvidia-settings".show()
	else:
		%"btn_nvidia-settings".hide()
		


func _apply_system_theme():
	if DisplayServer.is_dark_mode():
		self.set_theme(DARK_THEME)
	else:
		self.set_theme(LIGHT_THEME)

func _on_system_theme_changed():
	_apply_system_theme()




func _change_panel(panel) ->void:
	get_tree().change_scene_to_file("res://panels/"+panel+".tscn")


func _on_btn_users_pressed() -> void:
	OS.execute("kcmshell5",["kcm_users"])


func _on_btn_accounts_pressed() -> void:
	OS.execute("kcmshell5",["kcm_kaccounts"])


func _on_btn_kde_wallet_pressed() -> void:
	OS.execute("kwalletmanager5",[])


func _on_connections_pressed() -> void:
	OS.execute("kcmshell5",["kcm_networkmanagement"])


func _on_connections_2_pressed() -> void:
	OS.execute("kcmshell5",["proxy"])


func _on_autostart_pressed() -> void:
	OS.execute("kcmshell5",["kcm_autostart"])


func _on_manageapps_pressed() -> void:
	OS.execute("bash",["-c","plasma-discover --mode Installed"])


func _on_btn_power_saving_pressed() -> void:
	OS.execute("kcmshell5",["kcm_powerdevilprofilesconfig"])


func _on_btn_activity_power_settings_pressed() -> void:
	OS.execute("kcmshell5",["kcm_powerdevilactivitiesconfig"])


func _on_btn_advanced_power_settigns_pressed() -> void:
	OS.execute("kcmshell5", ["kcm_powerdevilglobalconfig"])
	
	
	
	
#ABOUT


func _on_btn_fullabout_pressed() -> void:
	OS.execute("kcmshell5",["kcm_about-distro"])


func _on_piper_pressed() -> void:
	OS.execute("piper",[])


func _on_btn_nvidiasettings_pressed() -> void:
	OS.execute("nvidia-settings",[])


func _on_fullsettings_pressed() -> void:
	OS.execute("systemsettings",[])


func _on_appscenter_pressed() -> void:
	OS.execute("plasma-discover",[])


func _on_loginscreen_pressed() -> void:
	OS.execute("kcmshell5",["kcm_sddm"])


func _on_backgroundservices_pressed() -> void:
	OS.execute("kcmshell5",["kcm_kded"])


func _on_lockscreen_pressed() -> void:
	OS.execute("kcmshell5",["kcm_screenlocker"])


func _on_desktopsession_pressed() -> void:
	OS.execute("kcmshell5",["kcm_smserver"])


func _on_managefonts_pressed() -> void:
	OS.execute("kcmshell5",["kcm_fontinst"]) #


func _on_wifi_pressed() -> void:
	OS.execute("plasmawindowed",["org.kde.plasma.networkmanagement"]) # plasmawindowed org.kde.plasma.networkmanagement


func _on_notifications_pressed() -> void:
	OS.execute("kcmshell5",["kcm_notifications"]) # # kcm_notifications
