extends Control

var title : String 
var icon_path : String
var target_position : Vector2 = Vector2.ZERO


signal change_speed_mode
signal execute

var animate_speed : float = 0.1
var debug_mode : bool = false

var is_mouse_within : bool = false
var is_button_pressed : bool = false

var launch_command : String

@export var TEXT_BOX : Label
@export var ICON : TextureRect
@export var BUTTON : TextureButton
@export var ANIM : AnimationPlayer

func _ready():
	TEXT_BOX.text = title
	
	if icon_path == "":
		icon_path = "res://icon.svg"
	
	var img = Image.new()
	var err = img.load(icon_path)
	var texture = ImageTexture.new()
	texture.set_image(img)
	ICON.texture = texture
	
	BUTTON.mouse_entered.connect(_mouse_entered)
	BUTTON.mouse_exited.connect(_mouse_exited)
	


func _physics_process(delta):
	position = lerp(position, target_position, animate_speed)


func _mouse_entered() -> void:
	is_mouse_within = true
	#if ANIM.is_playing() and ANIM.current_animation == "intro":
		#pass
	#ANIM.play("focus")
	ANIM.queue("focus")
	change_speed_mode.emit()

func _mouse_exited() -> void:
	is_mouse_within = false
	ANIM.queue("unfocus")
	change_speed_mode.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and is_mouse_within:
			ANIM.queue("click")
			is_button_pressed = true
		if not event.pressed and is_button_pressed:
			released()

func released():
	ANIM.queue("release")
	is_button_pressed = false
	if launch_command == "":
		print("Item Pressed has no command to execute")
		return
	
	execute.emit( "exe: " + launch_command + "%")
	get_tree().quit(0)


func _convert_to_click_mask():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(BUTTON.texture_normal.get_image())
	BUTTON.texture_click_mask = bitmap
