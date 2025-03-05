extends Node2D

const UDP_IP = "127.0.0.1"
const UDP_PORT = 42069
var server := UDPServer.new()

var ITEM = preload("res://Items/item_modern.tscn")
#var ITEM = preload("res://Items/item_circle.tscn")
var SUBMENU = preload("res://Items/sub_menu.tscn")
@onready var ROOT = $icon/centre
@onready var ROOT_ICON = $icon

var submenu_data = []
var root_item_data = []
var items = []
var total_items : int = 4
var current_section : int = 0
var speed_mode : bool = true
var within_submenu : bool = false

var config = ConfigFile.new()
var config_path = OS.get_environment("HOME") + "/.config/godot-pie"

var settings = {"animate_speed" : 0.2,
						"radius" : 250,
						"global_rotation" : 0,
						"centre_icon" : "res://icon.svg",
						"spawn_in_time" : 0.0}

var root_rotation : float

class SUBMENU_DATA:
	var title : String
	var icon_path : String
	var rotation : float
	var items : Array
	
	func _init(t, i, r):
		title = t
		icon_path = i
		rotation = r


func store_items(title, parent, icon_path, command):
	var item = ITEM_DATA.new(title, icon_path, command)
	
	if parent == "root":
		root_item_data.append(item)
		print("storing item: " + title + " in root")
		return
	else:
		for i in submenu_data:
			if i.title == parent:
				i.items.append(item)
				print("storing item: " + title + " in " + parent)
				return
	
	printerr("the root for item: " + title + " does not exist")

func create_item(item : ITEM_DATA):
	var e = ITEM.instantiate()
	e.title = item.title
	e.icon_path = item.icon_path
	e.launch_command = item.command
	e.animate_speed = settings["animate_speed"]
	e.change_speed_mode.connect(_change_speed_mode)
	e.execute.connect(send_execute_data)
	
	ROOT.add_child(e)
	items.append(e)
	e.position = Vector2.ZERO
	total_items = items.size()
	update_item_position()
	print("created item: " + item.title)

func store_submenu(title, icon_path, rotation):
	var s = SUBMENU_DATA.new(title, icon_path, rotation)
	submenu_data.append(s)
	root_item_data.append(s)

func create_submenu(submenu : SUBMENU_DATA):
	var s = SUBMENU.instantiate()
	s.title = submenu.title
	s.icon_path = submenu.icon_path
	s.items.append_array(submenu.items)
	s.animate_speed = settings["animate_speed"]
	s.change_speed_mode.connect(_change_speed_mode)
	s.load_submenu.connect( _load_submenu)
	ROOT.add_child(s)
	
	items.append(s)
	s.position = Vector2.ZERO
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
		items[i].target_position = Vector2(settings["radius"] * cos(theta * i + PI/total_items + settings["global_rotation"]), settings["radius"] * sin(theta * i + PI/total_items + settings["global_rotation"]))

func create_config():
	print("creating config....")
	
	#Global Settings
	for keys in settings.keys():
		config.set_value("Settings", keys, settings[keys])
	
	# Example Button
	config.set_value("Button 1", "Name", "HelloWorld")
	config.set_value("Button 1", "Type", "item or sub-menu")
	config.set_value("Button 1", "IconPath", "")
	config.set_value("Button 1", "parent", "root")
	config.set_value("Button 1", "Command", "xterm")
	config.set_value("Button 1", "Params", ["-e", "curl", "parrot.live"])
	var err = config.save(config_path + "/config.cfg")
	print("Save File Returned: " + str(err))
	

func load_config():
	print("loading config")
	for i in config.get_section_keys("Settings"):
		settings[i] = config.get_value("Settings", i)
	
	root_rotation = settings["global_rotation"]
	if settings["spawn_in_time"] != 0:
		$spawner.start(settings["spawn_in_time"])
	else:
		for i in config.get_sections():
			_spawn_item_from_section(i)
	
	create_root_layout()
	

func create_root_layout():
	for i in root_item_data:
		if i is ITEM_DATA:
			create_item(i)
		elif i is SUBMENU_DATA:
			create_submenu(i)
		
	update_root_icon(settings["centre_icon"])

func update_root_icon(image):
	var img = Image.new()
	var img_err = img.load(image)
	var texture = ImageTexture.new()
	texture.set_image(img)
	ROOT_ICON.texture = texture

func _spawn_item_from_section(item):
	if item == "Settings":
		return
	
	if config.get_value(item, "Type")== "sub-menu":
		store_submenu(config.get_value(item, "Name"), config.get_value(item, "IconPath"), config.get_value(item, "rotation"))
	if config.get_value(item, "Type") == "item":
		store_items(config.get_value(item, "Name"), config.get_value(item, "parent"), config.get_value(item, "IconPath"), config.get_value(item, "Command"))
	

func _on_item_spawner_timeout():
	var sections = config.get_sections()
	_spawn_item_from_section(sections[current_section])
	current_section += 1
	if current_section > sections.size() - 1:
		$spawner.stop()


func _ready():
	get_viewport().warp_mouse(Vector2(400, 400))
	$icon/anim.play("hover")
	if OS.get_name() == "Windows":
		config_path = OS.get_environment("APPDATA") + "/godot-pie"
			
	var err = config.load(config_path + "/config.cfg")
	if err != OK:
		if not DirAccess.dir_exists_absolute(config_path):
			DirAccess.make_dir_recursive_absolute(config_path)
		create_config()
	else:
		load_config()

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		settings["global_rotation"] -= 0.05
		print("rotated " + str(root_rotation - settings["global_rotation"]) + "radians from initial rotation")
		update_item_position()
	if Input.is_action_pressed("ui_right"):
		settings["global_rotation"] += 0.05
		print("rotated " + str(root_rotation - settings["global_rotation"]) + "radians from initial rotation")
		update_item_position()
	
	#$icon/pointer.look_at(get_global_mouse_position())
	#$icon/pointer.rotation += PI/2
	#var vec1 : Vector2 = -get_global_mouse_position() + $icon/pointer.global_position
	#vec1 = vec1.normalized()
	#var angle = sin(vec1.y)
	var angle = $icon/pointer.get_angle_to(get_global_mouse_position())
	$icon/pointer.rotation =  lerp($icon/pointer.rotation, $icon/pointer.rotation + angle + PI/2, 0.2)


func _input(event):

	if event.is_action_pressed("ui_cancel"):
		_on_centre_button_pressed()
	
	if event is InputEventMouseButton and event.pressed and speed_mode:
		var closest
		var dist = 100000
		for i in items:
			var temp = i.global_position.distance_to(get_global_mouse_position())
			if temp < dist:
				dist = temp
				closest = i
		
		if dist < settings["radius"] / 1.3:
			closest.released()

func send_execute_data(data : String):
	var peer : PacketPeerUDP = PacketPeerUDP.new()
	peer.set_dest_address(UDP_IP, UDP_PORT)
	peer.put_packet(data.to_ascii_buffer())
	peer.close()

func _load_submenu(submenu):
	
	clear_items()
	
	total_items = 0
	print(submenu.items)
	for i in submenu.items:
		create_item(i)

	within_submenu = true
	update_root_icon(submenu.icon_path)
	settings["global_rotation"] = submenu.rotation
	get_viewport().warp_mouse(Vector2(400, 400))
	$icon/anim.play("hover")

func _change_speed_mode():
	speed_mode = not speed_mode


func _on_centre_button_pressed():
	if within_submenu:
		clear_items()
		settings["global_rotation"] = root_rotation
		create_root_layout()
		within_submenu = false
		
		get_viewport().warp_mouse(Vector2(400, 400))
		$icon/anim.play("hover")
	else:
		get_tree().quit(0)


func _on_centre_button_mouse_entered():
	$icon/anim.play("hover")
	speed_mode = false

func _on_centre_button_mouse_exited():
	$icon/anim.play("unhover")
	speed_mode = true
