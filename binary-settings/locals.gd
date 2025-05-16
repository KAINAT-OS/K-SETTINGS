extends Control
@onready var btn_region_and_language: Button = %"btn_Region and Language"
@onready var btn_spell_checking: Button = %btn_Spell_Checking
@onready var btn_date_and_time: Button = %btn_Date_And_Time

func _ready() -> void:
	btn_region_and_language.connect("pressed",Callable(self,"on_btn_region_and_language_pressed"))
	btn_spell_checking.connect("pressed",Callable(self,"on_btn_spell_checking_pressed"))
	btn_date_and_time.connect("pressed",Callable(self,"on_btn_date_and_time_pressed"))
	
	
func on_btn_region_and_language_pressed() ->void :
	OS.execute("kcmshell5",["kcm_regionandlang"])
	
	
func on_btn_spell_checking_pressed() -> void:
		OS.execute("kcmshell5",["kcmspellchecking"])
	
	
func on_btn_date_and_time_pressed() -> void:
		OS.execute("kcmshell5",["kcm_clock"])
