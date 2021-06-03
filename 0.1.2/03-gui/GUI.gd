extends CanvasLayer

enum ARROW_STATES {EMPTY, MAP_CEN, MAP_E, MAP_W, COMBAT}
enum LABEL_STATES {EMPTY, TARGET, PROMPT, EAT}

var label
var arrows
var timer
var anim
var last_state = {
	"arrow": ARROW_STATES.EMPTY,
	"label": LABEL_STATES.TARGET
	}
var current_text= ""

func _ready():
	label = $Label
	timer = $Timer
	arrows = [$ArrowRight, $ArrowUp, $ArrowLeft, $ArrowDown]
	anim = $AnimationPlayer
	refresh(last_state["arrow"], last_state["label"])

func refresh(arrowstate, labelstate):
	match arrowstate:
		ARROW_STATES.EMPTY:
			for a in range(4):
				arrows[a].set_action(10)
		ARROW_STATES.MAP_CEN:
			for a in [0, 2]:
				arrows[a].set_action(a)
			for a in [1, 3]:
				arrows[a].set_action(10)
		ARROW_STATES.MAP_W:
			for a in [1, 2, 3]:
				arrows[a].set_action(10)
			arrows[0].set_action(0)
		ARROW_STATES.MAP_E:
			for a in [0, 1, 3]:
				arrows[a].set_action(10)
			arrows[2].set_action(2)
		ARROW_STATES.COMBAT:
			for a in range(4):
				arrows[a].set_action(a + 4) # check GuiArrow.gd (ENWS=APDD)

	match labelstate:
		LABEL_STATES.EMPTY:
			if anim.current_animation == "Write" \
			or label.percent_visible == 1:
				anim.stop()
				anim.play("Disappear")
			if !timer.is_stopped():
				timer.stop()
			current_text = ""
		LABEL_STATES.TARGET:
			print("writing target")
			write("Press TAB to cycle through targets.")
		LABEL_STATES.PROMPT:
			print("writing prompt")
			write("E: Confirm, ESC: Cancel")

	last_state["arrow"] = arrowstate
	last_state["label"] = labelstate

func write(txt):
	print(current_text)
	if current_text == txt:
		return
	elif current_text != "":
		anim.stop()
		anim.play("Disappear")
	timer.stop()
	current_text = txt
	label.percent_visible = 0
	label.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	timer.start()

func _on_Timer_timeout():
	anim.stop()
	label.text = current_text
	label.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	anim.play("Write")
