extends Control

onready var action = $Action
enum ACTIONS {E, N, W, S, ATTACK, PARRY, DODGE, DEFEND, UNKNOWN, IDLE, EMPTY}
const COMBAT_ACTIONS = ["attack", "parry", "dodge", "defend"]

func _ready():
	set_action(ACTIONS.EMPTY)

func set_action(f):
	action.frame = f
