tool
extends Node2D
class_name Character

# resources
#const RES_DIALOG = preload("res://scenes/DialogBox.tscn")
#const RES_TURN = preload("res://scenes/CombatTurn.tscn")

# pointers
onready var state_machine = $AnimationTree.get("parameters/playback")

# states
var is_dead := false
var rng
var facing := 1

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()

# ---
# dialog functions

# ---
# combat functions
