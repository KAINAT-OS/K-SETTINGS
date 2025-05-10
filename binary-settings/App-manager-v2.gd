extends Node
var output = []
var installed_apps = []
var app_icons = {}

func _ready() -> void:
	_fetch_installed_apps()
	_fetch_app_icons()
	create_app_list(installed_apps)

func _fetch_installed_apps() -> void:
	installed_apps.clear()
	var apps_dir = "/usr/share/applications"
	var dir = DirAccess.open(apps_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".desktop"):
				var app_id = file_name.replace(".desktop", "")
				installed_apps.append(app_id)
			file_name = dir.get_next()

func _fetch_app_icons() -> void:
	app_icons.clear()
	var apps_dir = "/usr/share/applications"
	var dir = DirAccess.open(apps_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".desktop"):
				# Construct the full path manually
				var desktop_path = apps_dir + "/" + file_name
				var f = FileAccess.open(desktop_path, FileAccess.READ)
				if f:
					var icon_name = ""
					while not f.eof_reached():
						var line = f.get_line()
						if line.begins_with("Icon="):
							icon_name = line.substr(5).strip_edges()
							break
					f.close()
					var app_id = file_name.replace(".desktop", "")
					if icon_name != "":
						app_icons[app_id] = icon_name
			file_name = dir.get_next()

func create_app_list(apps: Array) -> void:
	var vbox = $ScrollContainer/VBoxContainer
	for child in vbox.get_children():
		child.queue_free()
	for app_name in apps:
		var hbox = HBoxContainer.new()

		# Icon
		var texture = _get_icon_texture(app_name)
		var icon = TextureRect.new()
		icon.texture = texture
		icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

		# App name label
		var label = Label.new()
		label.text = app_name
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# Uninstall button
		var button = Button.new()
		button.text = "Uninstall"
		var cb = Callable(self, "_on_uninstall_pressed").bind(app_name)
		button.pressed.connect(cb)

		hbox.add_child(icon)
		hbox.add_child(label)
		hbox.add_child(button)
		vbox.add_child(hbox)

func _get_icon_texture(app_name: String) -> Texture:
	if app_icons.has(app_name):
		var icon_name = app_icons[app_name]
		var icon_path = icon_name
		if not icon_path.begins_with("/"):
			icon_path = "/usr/share/icons/hicolor/48x48/apps/" + icon_name + ".png"
		var img = Image.new()
		if img.load(icon_path) == OK:
			img.resize(32,32,Image.INTERPOLATE_CUBIC)
			var tex = ImageTexture.create_from_image(img)
			return tex
	# Fallback: return empty texture
	return ImageTexture.new()

func _on_uninstall_pressed(app_name: String) -> void:
	print("Requesting uninstall of %s" % app_name)
	OS.execute("pkexec", ["apt-get", "remove", "-y", app_name], [], true)
	_fetch_installed_apps()
	create_app_list(installed_apps)
