extends Node2D

# constructor variables
var turn_duration = 2
var turn_length = 8
var color = "light" # or dark, for enemy

# display variables
const COLORS = ["f0ece2", "313432"] # light, dark, green, red
var display_list = []

# timer variables
var cooldown = 0
var is_on_cooldown = false
var current_time = 0

# children
var background
var actions
var timer

func _ready():
	# set up background
	background = $Background
	actions = [$CurrentAction, $NextAction]
	display_list.append(background.get_node("ColorRect"))
	match color:
		"light":
			background.self_modulate = Color(COLORS[0])
			actions[0].self_modulate = Color(COLORS[0])
			actions[1].self_modulate = Color(COLORS[1])
			display_list[0].self_modulate = Color(COLORS[1])
		"dark":
			background.self_modulate = Color(COLORS[1])
			actions[0].self_modulate = Color(COLORS[1])
			actions[1].self_modulate = Color(COLORS[1])
			display_list[0].self_modulate = Color(COLORS[0])
	background.rect_size.x = 3 + (turn_length * 2)
	
	# set up small rectangles
	for a in range(turn_length - 1):
		var new_rect = ColorRect.new()
		new_rect.visible = false
		new_rect.rect_size = Vector2(1, 2)
		new_rect.rect_position = display_list[a].rect_position + Vector2(2, 0)
		match color:
			"light":
				new_rect.self_modulate = Color(COLORS[1])
			"dark":
				new_rect.self_modulate = Color(COLORS[0])
		background.add_child(new_rect)
		display_list.append(new_rect)
	
	# set up timer
	timer = $Timer
	timer.wait_time = float(turn_duration) / float(turn_length)
	timer.start()

func _on_Timer_timeout():
	if is_on_cooldown:
		cooldown -= 1
		if cooldown == 0:
			is_on_cooldown = false
	else:
		use_action()
	if current_time <= turn_length - 1:
		display_list[current_time].visible = true
		current_time += 1
	else:
		cooldown = 0
		is_on_cooldown = false
		current_time = 0
		for rect in display_list:
			rect.visible = false

func use_action():
	print("ACTION!")
	cooldown += 5
	is_on_cooldown = true
