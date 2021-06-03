extends Node

const GRASS_LEVEL = preload("res://scenes/GrassLevel.tscn")
const SPLASH = preload("res://scenes/Splash.tscn")

var current_scene

func _ready():
	current_scene = SPLASH.instance()
	add_child(current_scene)
	current_scene.connect("change_level", self, "change_level")

func change_level(lvl):
	var next_scene = load("res://scenes/%sLevel.tscn" % lvl).instance()
#	next_scene.connect("change_level", self, "change_level")
	add_child(next_scene)
	current_scene.queue_free()
	current_scene = next_scene
