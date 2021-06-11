extends KinematicBody2D
class_name Card

var held = false
var is_docked = false
var last_mouse_pos = Vector2()
var on_top = true
var mouse_in = false
var home_pos = Vector2()
var home_rot = 0
var left_color = "ffffff"
var right_color = "ffffff"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_class():
	return "Card"

# Called when the node enters the scene tree for the first time.
func _ready():
	home_pos = Vector2(position.x, position.y)
	home_rot = rotation_degrees
	randomize()
	var color_roll_left = randi() % 2
	var color_roll_right = randi() % 2
	match color_roll_left:
		0:
			left_color = "ff0000"
		1:
			left_color = "00ff00"
		2:
			left_color = "0000ff"
		3:
			left_color = "ff00ff"
	match color_roll_right:
		0:
			right_color = "ff0000"
		1:
			right_color = "00ff00"
		2:
			right_color = "0000ff"
		3:
			right_color = "ff00ff"
			
	get_node("Sprite/LeftColor").modulate = left_color
	get_node("Sprite/RightColor").modulate = right_color
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held:
		var mouse_pos = get_viewport().get_mouse_position()
		position += mouse_pos - last_mouse_pos
		last_mouse_pos = mouse_pos

func _on_Card_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed and on_top and !is_docked:
			held = true
			last_mouse_pos = event.position
			rotation_degrees = 0
		else:
			held = false
			position = Vector2(home_pos.x, home_pos.y)
			rotation_degrees = home_rot
			mouse_in = false
			z_index = 0


func _on_Card_mouse_entered():
	mouse_in = true


func _on_Card_mouse_exited():
	mouse_in = false
