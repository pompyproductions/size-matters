extends Node
class_name Level

# const RES_CHARACTER = preload()

const MOVE_INPUTS = {"ui_right": 1, "ui_left": -1}
const TILE_SIZE := 8
const ROOM_SIZE := 10
const FLOOR_Y := 12
const ROOM_MAX := 12
enum STATES {INACTIVE, IDLE, PROMPT, COMBAT}

var camera
var player
var tileset
var rng
var gui

var state = STATES.INACTIVE
var current_room := 0

var rooms := []
var enemy_pool := []

func _init():
	pass

func _ready():
	camera = $Camera
	tileset = $Floor

