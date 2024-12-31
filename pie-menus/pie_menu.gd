extends Node2D


var item = preload("res://item.tscn")
var items = []
var total_items : int = 4

var root

var config = ConfigFile.new()
var config_path = OS.get_environment("HOME") + "/.config/godot-pie"

var settings = {"animate_speed" : 0.2,
						"radius" : 250,
						"centre_icon" : "res://icon.svg",
						"debug_mode" : false}

func add_item(title, icon_path, command, flags):
	var e = item.instantiate()
	e.title = title
	e.icon_path = icon_path
	e.launch_command = command
	e.command_flags = []
	e.animate_speed = settings["animate_speed"]
	e.debug_mode = settings["debug_mode"]
	e.root = root
	$Centre.add_child(e)
	items.append(e)
	e.position = Vector2.ZERO
	total_items = items.size()
	update_item_position()


func remove_item():
	items[-1].queue_free()
	items.pop_back()
	total_items = items.size()
	update_item_position()

func clear_items():
	if items.size() > 0:
		for i in items.size():
			items[i].queue_free()
		items.clear()
	

func update_item_position():
	var theta = (2 * PI) / total_items
	for i in total_items:
		items[i].target_position = Vector2(settings["radius"] * cos(theta * i + PI/total_items), settings["radius"] * sin(theta * i + PI/total_items))


func create_config():
	print("creating config....")
	
	#Global Settings
	for keys in settings.keys():
		config.set_value("Settings", keys, settings[keys])
	
	# Example Button
	config.set_value("Button 1", "Name", "HelloWorld")
	config.set_value("Button 1", "IconPath", "")
	config.set_value("Button 1", "Command", "xterm")
	config.set_value("Button 1", "Flags", ["-e", "curl", "parrot.live"])
	var err = config.save(config_path + "/config.cfg")
	print("Save File Returned: " + str(err))
	

func load_config():
	print("loading config")
	for i in config.get_section_keys("Settings"):
		settings[i] = config.get_value("Settings", i)
		
	for i in config.get_sections():
		if i != "Settings":
			add_item(config.get_value(i, "Name"), config.get_value(i, "IconPath"), config.get_value(i, "Command"), config.get_value(i, "Flags"))
	
	var img = Image.new()
	var img_err = img.load(settings["centre_icon"])
	var texture = ImageTexture.new()
	texture.set_image(img)
	$Centre.texture = texture

func _ready():
	root = $Centre
	
	if OS.get_name() == "Windows":
		config_path = OS.get_environment("APPDATA") + "/godot-pie"
			
	var err = config.load(config_path + "/config.cfg")
	if err != OK:
		if not DirAccess.dir_exists_absolute(config_path):
			DirAccess.make_dir_recursive_absolute(config_path)
		create_config()
	else:
		load_config()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit(0)
