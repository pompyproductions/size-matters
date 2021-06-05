extends Node

const MOVE_INPUTS = {"ui_right": 1, "ui_left": -1}
const TILE_SIZE := 8
const ROOM_SIZE := 10
const FLOOR_Y := 12
const ROOM_MAX := 12
enum STATES {INACTIVE, IDLE, PROMPT, COMBAT}

# nodes and resources
var camera
var player
var tileset
var rng
var gui
var enemies
var menu
const res_room = preload("res://scripts/Room.gd")
const res_turn = preload("res://scenes/CombatTurn.tscn")
const res_menu = preload("res://scenes/Menu.tscn")

# states
var player_state = STATES.INACTIVE
var current_room = 0

# misc
var rooms: Array
var enemy_pool: Array
#signal change_level

func _ready():
	camera = $Camera
	player = $Player
	player.connect("activated", self, "on_player_activation")
	player.connect("move_complete", self, "on_player_move")
	player.facing = 1
	tileset = $Floor
	gui = $GUI
	enemies = $Enemies
	rng = RandomNumberGenerator.new()
	rng.randomize()

func _unhandled_key_input(event):
	var gui_state = [
		gui.last_state["arrow"],
		gui.last_state["label"]
			]
	match player_state:
		STATES.INACTIVE:
			if event.is_action_pressed("ui_focus_next"):
				if !player.active:
					player.activate()
				gui.refresh(gui_state[0], gui_state[1])
				return
				
		STATES.IDLE:
			# check for move input 
			for key in MOVE_INPUTS:
				if event.is_action_pressed(key):
					var dir = MOVE_INPUTS[key]
					if not current_room + dir in [-1, ROOM_MAX + 1]:
						if dir == player.facing:
							player.move(dir)
							camera.move(dir)
						else:
							player.change_dir(dir)
							camera.change_dir(dir)
						player_state = STATES.INACTIVE
						current_room += dir
						match current_room:
							0:
								gui_state[0] = gui.ARROW_STATES.MAP_W
							ROOM_MAX:
								gui_state[0] = gui.ARROW_STATES.MAP_E
							_:
								gui_state[0] = gui.ARROW_STATES.MAP_CEN
						if !rooms[current_room].discovered:
							new_procedural_room()
							rooms[current_room].discovered = true
					else:
						player.print_dialog("I can't go further.")
						if current_room + dir == ROOM_MAX + 1:
							gui_state[0] = gui.ARROW_STATES.MAP_E
						else:
							gui_state[0] = gui.ARROW_STATES.MAP_W
					gui.refresh(gui_state[0], gui_state[1])
					return
			
			# check for tab
			if event.is_action_pressed("ui_focus_next"):
				if !rooms[current_room].inv.empty():
					player.target(rooms[current_room].inv[0])
					player_state = STATES.PROMPT
					gui_state[1] = gui.LABEL_STATES.PROMPT
				gui.refresh(gui_state[0], gui_state[1])
				return

		STATES.PROMPT:
			if event.is_action_pressed("confirm"):
				match player.interact():
					"combat":
						enter_combat(rooms[current_room])
						player_state = STATES.COMBAT
				gui.refresh(gui_state[0], gui_state[1])
			elif event.is_action_pressed("ui_cancel") \
			or event.is_action_pressed("ui_left") \
			or event.is_action_pressed("ui_right"):
				player.target = null
				gui_state[1] = gui.LABEL_STATES.TARGET
				player_state = STATES.IDLE
				if player.current_dialog != null:
					player.dialog_clear()
				get_tree().set_input_as_handled()
				gui.refresh(gui_state[0], gui_state[1])
			return
		
		STATES.COMBAT:
			var actions = ["ui_right", "ui_up", "ui_left", "ui_down"]
			for act in range(4):
				if event.is_action_pressed(actions[act]):
					player.change_action(act)
			if player.current_dialog != null:
				player.dialog_clear()
			gui_state[0] = gui.ARROW_STATES.COMBAT
			gui_state[1] = gui.LABEL_STATES.TARGET
			gui.refresh(gui_state[0], gui_state[1])
			if event.is_action_pressed("ui_cancel"):
				gui_state[0] = gui.ARROW_STATES.MAP_CEN
				exit_combat(rooms[current_room])
				player_state = STATES.IDLE
				gui.refresh(gui_state[0], gui_state[1])
				return

	if event.is_action_pressed("ui_cancel"):
		open_menu()

# ---
# room generation
func new_room(pos=0, size=10, spawn=false):
	var room = res_room.new(pos, size, [])
	for tile in range(size):
		if tile % 2 == 0:
			place_tile(pos + tile, rng.randi_range(0, 1) * 2)
		else:
			place_tile(pos + tile, 1)
	# enter special room logic here
	if spawn:
		var enemy_res = load("res://scenes/enemies/BirdGreen.tscn")
		var enemy = enemy_res.instance()
		enemy.position = Vector2(
			(room.pos + 3) * TILE_SIZE,
			(FLOOR_Y - 1) * TILE_SIZE
		)
		enemies.add_child(enemy)
		room.inv.append(enemy)
		
	rooms.append(room)

func new_procedural_room(spawn=true):
	new_room(rooms[-1].pos + rooms[-1].size, ROOM_SIZE, spawn)

func place_tile(pos, tile):
	tileset.set_cell(pos, FLOOR_Y, tile)
	tileset.update_dirty_quadrants()

# ---
# player signals
func on_player_activation():
	gui.refresh(gui.ARROW_STATES.MAP_W, gui.LABEL_STATES.EMPTY)
	player_state = STATES.IDLE

func on_player_move():
	if player_state == STATES.INACTIVE:
		player_state = STATES.IDLE
	var gui_state = []
	match current_room:
		0:
			gui_state.append(gui.ARROW_STATES.MAP_W)
		ROOM_MAX:
			gui_state.append(gui.ARROW_STATES.MAP_E)
		_:
			gui_state.append(gui.ARROW_STATES.MAP_CEN)
	match rooms[current_room].inv.empty():
		false:
			gui_state.append(gui.LABEL_STATES.TARGET)
		true:
			gui_state.append(gui.LABEL_STATES.EMPTY)
	print(gui_state)
	gui.refresh(gui_state[0], gui_state[1])

# ---
# combat
func enter_combat(room):
	if player.current_dialog != null:
		player.dialog_clear()
	var turn_node = res_turn.instance()
	turn_node.custom_init() # default val for player
	turn_node.connect("turn_over", player, "on_turn_over") # make function
	turn_node.connect("action", player, "play_action") # make function
	turn_node.position = Vector2(32, -8)
	player.turn = turn_node
	player.add_child(turn_node)
	for enemy in room.inv:
		turn_node = res_turn.instance()
		turn_node.custom_init(false, enemy.turn_duration)
		turn_node.position = Vector2(0, -16)
		enemy.turn = turn_node
		turn_node.connect("turn_over", enemy, "on_turn_over") # make function
		turn_node.connect("action", enemy, "play_action") # make function
		enemy.add_child(turn_node)

func exit_combat(room):
	player.turn.queue_free()
	player.turn = null
	for enemy in room.inv:
		if !enemy.dead:
			enemy.turn.queue_free()
			enemy.turn = null

# ---
# menu
func open_menu():
	var new_menu = res_menu.instance()
	menu = new_menu
	menu.connect("menu_close", self, "close_menu")
	gui.add_child(menu)

func close_menu():
	menu.queue_free()
	menu = null
