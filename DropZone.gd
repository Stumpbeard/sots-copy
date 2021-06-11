extends Area2D

var held_card
var furthest_empty = false
var floating_bodies = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_class():
	return "DropZone"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DropRadius_body_shape_entered(body_id, body, body_shape, local_shape):
	if furthest_empty:
		floating_bodies.append(body)


func _on_DropRadius_body_shape_exited(body_id, body, body_shape, local_shape):
	if furthest_empty:
		floating_bodies.erase(body)
