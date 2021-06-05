extends Node

onready var button = $Button
signal change_level

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		_on_Button_pressed()

func _on_Button_pressed():
	emit_signal("change_level", "Level_Grass")
