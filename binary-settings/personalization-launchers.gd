extends Control

@onready var icon_settings: Button = %"Icon-settings"
@onready var font_manager: Button = %"font-manager"
@onready var color: Button = %color

var output_array=[]

func _ready() -> void:
	icon_settings.connect("pressed",Callable(self,"icon_settings_on_pressed"))
	font_manager.connect("pressed",Callable(self,"font_manager_on_pressed"))
	color.connect("pressed",Callable(self,"color_on_pressed"))

func icon_settings_on_pressed():
	var result = OS.execute("kcmshell5",["kcm_icons"],[],true)


func font_manager_on_pressed():
	var result = OS.execute("kcmshell5",["kcm_fonts"],[],true)


func color_on_pressed():
	var result = OS.execute("kcmshell5",["kcm_colors"],[],true)
