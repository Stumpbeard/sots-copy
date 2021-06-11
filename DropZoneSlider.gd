extends Area2D

var dragging = false
var last_mouse_pos = Vector2()
var drop_zones = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.get_class() == "DropZone":
			drop_zones.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		var mouse_pos = get_global_mouse_position()
		position.x += mouse_pos.x - last_mouse_pos.x
		for drop_zone in drop_zones:
			if drop_zone.held_card:
				drop_zone.held_card.position.x += mouse_pos.x - last_mouse_pos.x
				drop_zone.held_card.home_pos.x += mouse_pos.x - last_mouse_pos.x
		last_mouse_pos = mouse_pos
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if !event.pressed:
				dragging = false
				
func _on_DropZoneSlider_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_pos = get_global_mouse_position()
