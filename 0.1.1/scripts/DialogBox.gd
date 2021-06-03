extends NinePatchRect

var duration = 2
var displayed = false
var text

onready var anim_player = $AnimationPlayer
var label
onready var tween = $Tween
onready var timer = $Timer

signal freeing

func _ready():
	modulate.a = 0
	label = $Label
	label.text = text
	timer.start()

func _on_Timer_timeout():
	if displayed:
		anim_player.play("Disappear")
	else:
		anim_player.play("Popup")
		displayed = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Popup":
		resize()
	elif anim_name == "Write":
		timer.wait_time = duration
		timer.start()
	else:
		emit_signal("freeing", self)
		queue_free()

func resize():
	tween.interpolate_property(self, "rect_size", 
	rect_size, Vector2(16 + label.get_minimum_size().x, rect_size.y), 
	0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_completed(_object, _key):
	anim_player.play("Write")
