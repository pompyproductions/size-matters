extends Node

# nodes and interaction
var state_machine
var interaction = "enemy"
var dead = false
var rng

# combat variables
var pattern = "mob" # can be boss too
var turn
var turn_duration
var actions = range(10).slice(4, -1) # {E, N, W, S, ATTACK, PARRY, DODGE, DEFEND, UNKNOWN, IDLE, EMPTY} 

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	rng = RandomNumberGenerator.new()
	rng.randomize()

# ---
# combat functions
func set_next_action(act=pattern):
	match act:
		"mob":
			var pool = range(4)
			turn.set_next_action(pool[rng.randi_range(0, 3)])

func on_turn_over(act=pattern):
	print("turn over")
	set_next_action(act)

func play_action(act):
	print("enemy action")
	state_machine.travel("Action")
