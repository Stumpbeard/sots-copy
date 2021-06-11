extends Node2D

var card_scene = preload("res://Card.tscn")

var cards = []
var hand = []
var drop_zones = []
var max_card_z = 0
var furthest_left_drop_zone = 1
var HAND_POS = [
	{"pos": Vector2(128, 2080), "rot": -30},
	{"pos": Vector2(320, 1984), "rot": -15},
	{"pos": Vector2(544, 1954), "rot": 0},
	{"pos": Vector2(768, 1984), "rot": 15},
	{"pos": Vector2(960, 2080), "rot": 30},
]
var wins = 0
var losses = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.get_class() == "Card":
			cards.append(child)
			hand.append(child)
			child.on_top = false
	
	for node in get_node("DropZoneSlider").get_children():
		if node.get_class() == "DropZone":
			drop_zones.append(node)
			
	drop_zones[furthest_left_drop_zone].furthest_empty = true
	var new_card = card_scene.instance()
	add_child(new_card)
	drop_zones[0].held_card = new_card
	new_card.position = drop_zones[0].global_position
	new_card.home_rot = 0
	new_card.home_pos = drop_zones[0].global_position
	new_card.is_docked = true
	
			
func _input(event):
	if event is InputEventMouseButton:
		var top_card = null
		for card in cards:
			if card.mouse_in:
				if top_card == null or card.z_index > top_card.z_index:
					top_card = card
				card.on_top = false
			card.z_index = 0
		if top_card:
			top_card.on_top = true
			top_card.z_index = 1
			
		if event.button_index == BUTTON_LEFT and !event.pressed:
			if furthest_left_drop_zone >= drop_zones.size():
				return
			var held_card
			for card in cards:
				if card.held:
					held_card = card
					break
			if held_card and drop_zones[furthest_left_drop_zone].floating_bodies and drop_zones[furthest_left_drop_zone].floating_bodies.find(held_card) > -1:
				if held_card.left_color == drop_zones[furthest_left_drop_zone - 1].held_card.right_color:
					var left_drop_zone = drop_zones[furthest_left_drop_zone]
					left_drop_zone.held_card = held_card
					var hand_index = hand.find(held_card)
					for i in range(hand_index + 1, hand.size()):
						hand[i].position = HAND_POS[i-1]["pos"]
						hand[i].rotation_degrees = HAND_POS[i-1]["rot"]
						hand[i].home_pos = HAND_POS[i-1]["pos"]
						hand[i].home_rot = HAND_POS[i-1]["rot"]
						hand[i-1] = hand[i]

					held_card.home_rot = 0
					held_card.home_pos = Vector2(left_drop_zone.global_position.x, left_drop_zone.global_position.y)
					held_card.is_docked = true
					drop_zones[furthest_left_drop_zone].furthest_empty = false
					furthest_left_drop_zone += 1

					var new_card = card_scene.instance()
					new_card.position = Vector2(960, 2080)
					new_card.rotation_degrees = 30
					new_card.home_pos = Vector2(960, 2080)
					new_card.home_rot = 30
					hand[hand.size()-1] = new_card
					cards.append(new_card)
					add_child(new_card)
						
					if furthest_left_drop_zone < drop_zones.size():
						drop_zones[furthest_left_drop_zone].furthest_empty = true
					else:
						wins += 1
						print("you have ", wins, " wins")
						furthest_left_drop_zone = 1
						drop_zones[0].held_card = drop_zones.back().held_card
						drop_zones[0].held_card.position = drop_zones[0].global_position
						drop_zones[0].held_card.home_pos = drop_zones[0].global_position
						for drop_zone in drop_zones.slice(1, drop_zones.size() - 1):
							var card_to_go = drop_zone.held_card
							cards.erase(card_to_go)
							card_to_go.position = Vector2(-5000, -5000)
							drop_zone.held_card = null
						drop_zones[furthest_left_drop_zone].furthest_empty = true
