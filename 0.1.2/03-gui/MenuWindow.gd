extends NinePatchRect


const res_button = preload("res://scripts/MenuButton.gd")
const res_icon = preload("res://scenes/MenuIcon.tscn")

var current_focus
var buttons = []
var menu_type = "init"

# post-constructor (add btns on ready)
const ITEMS_INIT = ["Stats", "Skills", "Help", "About"]
const ITEMS_STATS = []
const ITEMS_SKILLS = ["Attack", "Parry", "Dodge", "Defend"]
const ITEMS_HELP = []
const ITEMS_ABOUT = []
var con_buttons = [] # rework this part and remove con_buttons.
# the ITEMS_whatever, replace them with dicts with following keys:
# "type", "content", and whatever else might be necessary.


func custom_init(pos=Vector2(12, 12), 
	items=["Stats", "Skills", "Help", "About"], 
	menutype="init"):
	con_buttons = items
	margin_left = pos.x
	margin_top = pos.y

func _ready():
	var lwidth = 0
	match menu_type:
		"init":
			for btn in con_buttons:
				var new_button = add_button(btn)
				if !buttons.empty():
					new_button.margin_top = buttons[-1].margin_top + 15
					new_button.margin_bottom = buttons[-1].margin_bottom + 15
				if new_button.margin_right > lwidth:
					lwidth = new_button.get_minimum_size().x
				buttons.append(new_button)
				add_child(new_button)
			margin_right = margin_left + lwidth
			print(buttons.size())
			margin_bottom = buttons.size() * 18 + 4
			current_focus = 0
			refresh_display()
	
func add_button(btn:String, icon=""):
	var l = Label.new()
	l.set_script(res_button)
	l.custom_init(btn, icon)
	return l

func refresh_display():
	for btn in buttons:
		btn.self_modulate = btn.COLORS[1]
	buttons[current_focus].self_modulate = buttons[current_focus].COLORS[0]

func focus(a=1):
	current_focus = (current_focus + a) % buttons.size()
	refresh_display()
