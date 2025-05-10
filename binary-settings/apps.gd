extends Node

var installed_apps: Array = []
var app_icons: Dictionary = {}
var desktop_dir: String = "/usr/share/applications"

func _ready() -> void:
	_refresh_app_list()

# Refresh both the installed_apps array and the UI list
func _refresh_app_list() -> void:
	installed_apps = []
	app_icons.clear()

	var dir = DirAccess.open(desktop_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".desktop"):
				var app_id: String = file_name.replace(".desktop", "")
				installed_apps.append({
					"id": app_id,
					"desktop_file": desktop_dir + "/" + file_name
				})
			file_name = dir.get_next()

	# after collecting desktop files, fetch their icons
	for app in installed_apps:
		app_icons[app.id] = _read_icon_name(app.desktop_file)

	_build_ui_list()

# Read the Icon= entry from a .desktop file
func _read_icon_name(path: String) -> String:
	var icon_name: String = ""
	var f = FileAccess.open(path, FileAccess.READ)
	if f:
		while not f.eof_reached():
			var line := f.get_line().strip_edges()
			if line.begins_with("Icon="):
				icon_name = line.substr(5)
				break
		f.close()
	return icon_name

# Build the scrollable UI list of apps
func _build_ui_list() -> void:
	var vbox = %VBoxContainer
	for child in vbox.get_children():
		child.queue_free()

	for app in installed_apps:
		var hbox = HBoxContainer.new()

		# Icon
		var icon_tex = _get_icon_texture(app.id)
		var icon = TextureRect.new()
		icon.texture = icon_tex
		icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		# Label
		var label = Label.new()
		label.text = app.id
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# Uninstall button
		var btn = Button.new()
		btn.text = "Uninstall"
		btn.connect("pressed", Callable(self, "_on_uninstall_pressed").bind(app))

		hbox.add_child(icon)
		hbox.add_child(label)
		hbox.add_child(btn)
		vbox.add_child(hbox)

# Get GDScript Texture from the stored icon name
func _get_icon_texture(app_id: String) -> Texture:
	if app_icons.has(app_id) and app_icons[app_id] != "":
		var icon_name: String = app_icons[app_id]
		var path: String = icon_name
		if not path.begins_with("/"):
			path = "/usr/share/icons/hicolor/48x48/apps/" + icon_name + ".png"
		var img = Image.new()
		if img.load(path) == OK:
			img.resize(32, 32, Image.INTERPOLATE_CUBIC)
			return ImageTexture.create_from_image(img)
	return ImageTexture.new()

# Handle the uninstall press: determine package via dpkg -S, then remove
func _on_uninstall_pressed(app_data: Dictionary) -> void:
	var desktop_path: String = app_data.desktop_file
	# Query dpkg for the owning package
	var result: Array = []
	OS.execute("dpkg", ["-S", desktop_path], result, true)
	var pkg: String = ""
	if result.size() > 0:
		# output format: "package: /usr/share/applications/..."
		var parts = result[0].split(":")
		pkg = parts[0].strip_edges()
	if pkg != "":
		# Ask for privilege elevation to remove
		OS.execute("pkexec", ["apt-get", "remove", "-y", pkg], [], true)
		# Refresh the list
		_refresh_app_list()
	else:
		print("Could not determine package for %s" % desktop_path)
