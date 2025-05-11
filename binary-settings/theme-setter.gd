extends Control
@onready var dark_theme: Button = %"Dark-theme"
@onready var light_theme: Button = %"Light-theme"
var dark_theme_name="com.K-dark.gg"
var light_theme_name="com.K-light.gg"

var output_array=[]

func _ready() -> void:
	dark_theme.connect("pressed",Callable(self,"dark_theme_on_pressed"))
	light_theme.connect("pressed",Callable(self,"light_theme_on_pressed"))

func dark_theme_on_pressed():
	var result = OS.execute("lookandfeeltool",["-a",dark_theme_name],[],true)


func light_theme_on_pressed():
	var result = OS.execute("lookandfeeltool",["-a",light_theme_name],[],true)
