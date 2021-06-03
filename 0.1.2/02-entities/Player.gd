extends Node2D

onready var tween = $Tween
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var timer = $Timer

var active = false
var facing = 1
var target

# stats
var weight = 0 # evolve() sets this back to 0
var size = 1 # evolve() -> += 1
var level = 1 # gain_xp(xp), triggered from LEVEL

# combat
var turn

const res_dialog = preload("res://scenes/DialogBox.tscn")
var dialog_vars = ["Text n/a", 2]
var current_dialog

signal move
signal activated
signal move_complete

# ---
# movement functions
func activate():
	state_machine.travel("Idle")
	print_dialog("*yawn*", 0.6) # "Press E to eat!"

func move(dir):
	tween.interpolate_property(self, "position", 
	position, position + Vector2(80 * dir, 0), 
	1.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	emit_signal("move", dir)
	match dir:
		1:
			state_machine.travel("Move")
		-1:
			state_machine.travel("MoveBack")

func change_dir(dir):
	tween.interpolate_property(self, "position", 
	position, position + Vector2(16 * dir, 0), 
	0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	if facing == 1:
		state_machine.travel("IdleBack")
		facing = -1
	else:
		state_machine.travel("Idle")
		facing = 1

func _on_Tween_tween_completed(_object, _key):
	match facing:
		1:
			state_machine.travel("Idle")
		-1:
			state_machine.travel("IdleBack")
	emit_signal("move_complete")

# ---
# dialog functions
func print_dialog(txt, appear=0.1, disappear=2):
	if current_dialog != null:
		dialog_clear()
	timer.wait_time = appear
	dialog_vars = [txt, disappear]
	timer.start()

func _on_Timer_timeout():
	var dialog = res_dialog.instance()
	dialog.text = dialog_vars[0]
	dialog.duration = dialog_vars[1]
	dialog.connect("freeing", self, "on_dialog_free")
	$DialogInsert.add_child(dialog)
	current_dialog = dialog
	if !active:
		emit_signal("activated")
		active = true

func on_dialog_free(node):
	if current_dialog == node:
		current_dialog = null

func dialog_clear():
	print(current_dialog)
	current_dialog.timer.stop()
	current_dialog.anim_player.stop()
	current_dialog.anim_player.play("Disappear")
	current_dialog = null

# ---
# targeting functions
func target(node):
	target = node
	match node.interaction:
		"enemy":
			if !node.dead:
				print_dialog("Enter combat?", 0.02, 180)
			else:
				print_dialog("Consume the remains?", 0.02, 180)
		"down":
			print_dialog("Go down?", 0.02, 180)
		"raft":
			print_dialog("Board the raft?", 0.02, 180)

func interact():
	match target.interaction:
		"enemy":
			if !target.dead:
				return "combat"
			else:
				weight += target.weight
				if weight >= 4: # how to make this scale up? maybe [weight, size]
					# evolve
					pass
				return "consume"
		"raft":
			pass
		"down":
			if size > 1:
				pass # don't fit
			else:
				pass # change level

# ---
# combat functions
func change_action(act):
	turn.set_next_action(act)
	turn.icon_refresh()

func on_turn_over(act):
	play_action(act)

func play_action(_act):
	print("player action")
	turn.icon_refresh()
	state_machine.travel("Action")
