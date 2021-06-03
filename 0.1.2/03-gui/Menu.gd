extends Control

const res_window = preload("res://scenes/MenuWindow.tscn")
var current_window = []
signal menu_close

func _ready():
	var new_window = res_window.instance()
	new_window.custom_init()
	add_child(new_window)
	current_window.append(new_window)
	refresh_display()

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_down") \
		or event.is_action_pressed("ui_focus_next"):
		focus_next()
	elif event.is_action_pressed("ui_up"):
		focus_prev()
	elif event.is_action_pressed("ui_cancel"):
		close_window()
	elif event.is_action_pressed("ui_left"):
		if current_window.size() > 1:
			close_window()
	elif event.is_action_pressed("ui_accept") \
		or event.is_action_pressed("confirm") \
		or event.is_action_pressed("ui_right"):
		open_window(current_window[-1])
	get_tree().set_input_as_handled()

func focus_next():
	current_window[-1].focus()
	refresh_display()

func focus_prev():
	current_window[-1].focus(-1)
	refresh_display()

func close_window():
	current_window.pop_back().queue_free()
	if !current_window.empty():
		refresh_display()
	else:
		emit_signal("menu_close")

func open_window(win):
	match win.buttons[win.current_focus].text:
		"Skills":
			var new_window = res_window.instance()
			new_window.custom_init(
				Vector2(win.margin_right + 4, 12),
				["Block", "Parry", "Attack", "Dodge"],
				"init"
			)
			add_child(new_window)
			current_window.append(new_window)
			refresh_display()
func refresh_display():
	for win in current_window:
		win.modulate.a = 0.6
	current_window[-1].modulate.a = 1
	current_window[-1].refresh_display()
