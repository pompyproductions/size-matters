extends "res://scripts/Level.gd"

func _init():
	enemy_pool = [
		["BirdGreen", 60],
		["BirdBrown", 70],
		["BirdBlue", 80],
		["BirdPurple", 90],
		["BirdRed", 100]
	]

func _ready():
	new_room(-10, 30)
	for _a in range(3):
		new_procedural_room(true)
