extends Control
@onready var btn_printer: Button = %btn_printer
@onready var btn_audio: Button = %btn_audio
@onready var btn_kde_connect: Button = %"btn_kde-connect"

var output_array=[]

func _ready() -> void:
	btn_printer.connect("pressed",Callable(self,"btn_printer_on_pressed"))
	btn_audio.connect("pressed",Callable(self,"btn_audio_on_pressed"))
	btn_kde_connect.connect("pressed",Callable(self,"btn_kde_connect_on_pressed"))

func btn_printer_on_pressed():
	var result = OS.execute("kcmshell5",["kcm_printer_manager"],[],true)


func btn_audio_on_pressed():
	var result = OS.execute("kcmshell5",["kcm_pulseaudio"],[],true)


func btn_kde_connect_on_pressed():
	var result = OS.execute("kcmshell5",["kcm_kdeconnect"],[],true)
