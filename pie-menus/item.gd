extends Node2D


var title : String 
var icon_path : String
var target_position : Vector2 = Vector2.ZERO
var root = null

var animate_speed : float = 0.1
var debug_mode : bool = false

var is_mouse_within : bool = false
var is_button_pressed : bool = false

var launch_command : String
var command_flags = []

func _ready():
	$Label.text = title
	if icon_path == "":
		icon_path = "res://icon.svg"

	var img = Image.new()
	var err = img.load(icon_path)
	var texture = ImageTexture.new()
	texture.set_image(img)
	$Icon.texture = texture


func _physics_process(delta):
	position = lerp(position, target_position, animate_speed)


func _on_area_2d_mouse_entered() -> void:
	is_mouse_within = true
	$AnimationPlayer.play("hover")

func _on_area_2d_mouse_exited() -> void:
	is_mouse_within = false
	$AnimationPlayer.play("unhover")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and is_mouse_within:
			$AnimationPlayer.play("pressed")
			is_button_pressed = true
		if not event.pressed and is_button_pressed:
			released()

func released():
	$AnimationPlayer.play("released")
	is_button_pressed = false
	if launch_command == "":
		print("Item Pressed has no command to execute")
		return
	
	if debug_mode:
		var output = []
		OS.execute(launch_command, command_flags, output, true)
		print("This is the output from the executed program: ")
		print(output)
	else:
		OS.execute_with_pipe(launch_command, command_flags)
		get_tree().quit(0)
