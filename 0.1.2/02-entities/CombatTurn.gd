extends Node2D

# constructor variables
var turn_duration = 2
var turn_length = 9
var color = "light" # or dark, for enemy
var actions = range(10).slice(4, -1)

# display variables
const COLORS = ["f0ece2", "313432"] # light, dark, green, red
var display_list = []

# timer variables
var current_time = 0

# children
var node_bg
var node_actions
var timer

# combat variables
var current_action

signal action
signal turn_over

func custom_init(is_player=true, 
	duration=2,
	length=9
	):
	turn_duration = duration
	turn_length = length
	if is_player:
		color = "light"
	else:
		color = "dark"
	current_action = [9, 9]
			

func _ready():
	# set up node_bg
	node_bg = $Background
	node_actions = [$CurrentAction, $NextAction]
	display_list.append(node_bg.get_node("ColorRect"))
	match color:
		"light":
			node_bg.self_modulate = Color(COLORS[0])
			node_actions[0].self_modulate = Color(COLORS[0])
			node_actions[1].self_modulate = Color(COLORS[1])
			display_list[0].self_modulate = Color(COLORS[1])
		"dark":
			node_bg.self_modulate = Color(COLORS[1])
			node_actions[0].self_modulate = Color(COLORS[1])
			node_actions[1].self_modulate = Color(COLORS[1])
			display_list[0].self_modulate = Color(COLORS[0])
	node_bg.rect_size.x = 3 + (turn_length * 2)
	
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
		node_bg.add_child(new_rect)
		display_list.append(new_rect)
	
	# set up timer
	timer = $Timer
	timer.wait_time = float(turn_duration) / float(turn_length)
	timer.start()
	
	# refresh icons
	icon_refresh()

func _on_Timer_timeout():
	if current_time <= turn_length - 1:
		display_list[current_time].visible = true
		if current_time == floor(turn_length / 2):
			use_action(current_action[0])
		current_time += 1
	else:
		emit_signal("turn_over")
		use_action(current_action[1])
		current_action[1] = current_action[0]
		current_time = 0
		for rect in display_list:
			rect.visible = false
		icon_refresh()

func use_action(act):
	emit_signal("action", act) # 0: next, 1: current

func set_next_action(act):
	current_action[0] = actions[act]

func icon_refresh():
	for a in range(2):
		node_actions[a].frame = current_action[a]
