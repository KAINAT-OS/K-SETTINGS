extends Node
var output=[]
var installed_apps = []

func _ready() -> void:
	_fetch_installed_apps()
	create_app_list(installed_apps)

func _fetch_installed_apps() -> void:
	output.clear() 
	# blocking=true, output in `output`
	OS.execute("/bin/bash", ["-c","dpkg --get-selections"], output)
	var output2 :PackedStringArray = output[0].split("\n")
	installed_apps.clear()
	for line in output2:
		var parts = line.split("\t")
		installed_apps.append(parts[0])
			

func create_app_list(apps) -> void:
	var vbox = $ScrollContainer/VBoxContainer
	# clear previous children
	for child in vbox.get_children():
		child.queue_free()
	# build entries
	for app_name:String in apps:
		var hbox = HBoxContainer.new()

		var label = Label.new()
		label.text = app_name
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var button = Button.new()
		button.text = "Uninstall"
		# correct signal connection:
		var cb = Callable(self, "_on_uninstall_pressed").bind(app_name)
		button.pressed.connect(Callable(cb))

		hbox.add_child(label)
		hbox.add_child(button)
		vbox.add_child(hbox)

func _on_uninstall_pressed(app_name: String) -> void:
	print("Requesting uninstall of ", app_name)
	OS.execute("pkexec", ["apt-get", "remove", "-y", app_name], [], true)
	# refresh list so UI updates
	_fetch_installed_apps()
	create_app_list(installed_apps)
