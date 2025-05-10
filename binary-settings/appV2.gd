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
				installed_apps.append({
					"id": file_name,
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
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# Icon
		var icon_tex = _get_icon_texture(app.id)
		var icon = TextureRect.new()
		icon.texture = icon_tex
		icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		# App Name Button
		var name_button = Button.new()
		name_button.text = app.id.replace(".desktop", "")
		name_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_button.flat = true
		name_button.connect("pressed", Callable(self, "_on_app_clicked").bind(app))

		# Uninstall button
		var btn_uninstall = Button.new()
		btn_uninstall.text = "Uninstall"
		btn_uninstall.connect("pressed", Callable(self, "_on_uninstall_pressed").bind(app))

		hbox.add_child(icon)
		hbox.add_child(name_button)
		hbox.add_child(btn_uninstall)
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

# Handle clicking on the app name: search Google for Debian package using default browser
func _on_app_clicked(app_data: Dictionary) -> void:
	var desktop_path: String = app_data.desktop_file
	# Extract desktop filename (e.g. "org.kde.foo.desktop") and remove extension
	var file_name: String = desktop_path.get_file().replace(".desktop", "")
	# Build Google search query for Debian package (spaces become '+')
	var query: String = file_name + "+debian+package"
	var url: String = "https://www.google.com/search?q=" + query
	# Open in default browser
	OS.execute("xdg-open", [url], [], false)

# Handle the uninstall press: determine package via dpkg -S, then remove
func _on_uninstall_pressed(app_data: Dictionary) -> void:
	var desktop_path: String = app_data.desktop_file
	var result: Array = []
	OS.execute("dpkg", ["-S", desktop_path], result, true)
	var pkg: String = ""
	if result.size() > 0:
		pkg = result[0].split(":")[0].strip_edges()
	if pkg != "":
		OS.execute("pkexec", ["apt-get", "remove", "-y", pkg], [], true)
		_refresh_app_list()
	else:
		print("Could not determine package for %s" % desktop_path)
