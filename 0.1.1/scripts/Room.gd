extends Node

var size
var pos
var inv = []
var discovered = false

func _init(i_pos, i_size, i_inv):
	size = i_size
	pos = i_pos
	inv = i_inv
	print([size, pos])

func _ready():
	pass
