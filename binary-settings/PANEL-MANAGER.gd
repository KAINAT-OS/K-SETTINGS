extends MarginContainer

var panels: Array[PanelContainer]=[]
@onready var display: Button = %display
@onready var input: Button = %input
@onready var apps: Button = %Apps
@onready var update: Button = %Update
@onready var personalization: Button = %personalization
@onready var button_6: Button = %Button6
@onready var button_7: Button = %Button7
@onready var button_8: Button = %Button8
@onready var button_9: Button = %Button9
@onready var button_10: Button = %Button10


func _ready() -> void:
	panels=[%Display, %Inputs, %APPS, %UPDATE, %PERSONALIZATION]
	
	display.pressed.connect(show_panel.bind(panels[0]))
	input.pressed.connect(show_panel.bind(panels[1]))
	apps.pressed.connect(show_panel.bind(panels[2]))
	update.pressed.connect(show_panel.bind(panels[3]))
	personalization.pressed.connect(show_panel.bind(panels[4]))
	show_panel(panels[0])
func show_panel(panel_to_show:PanelContainer) -> void:
	for panel in panels:
		panel.hide()
	panel_to_show.show()
