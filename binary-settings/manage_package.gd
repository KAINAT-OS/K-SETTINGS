extends Button
@onready var manage_package: Button = %manage_package

func _ready() -> void:
	manage_package.pressed.connect(Callable(_on_pressed))

func _on_pressed() -> void:
	var out=[]
	OS.execute("synaptic-pkexec",[],out)
	print(out)
