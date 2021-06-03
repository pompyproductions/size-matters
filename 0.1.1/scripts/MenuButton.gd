extends Label

const COLORS = ["f0ece2", "a2909f"]

func custom_init(txt, icon=false):
    text = txt
    self_modulate = COLORS[1]
    margin_bottom = 19
    margin_left = 4
    margin_right = margin_left + get_minimum_size().x
    if icon:
        margin_right += 9
        margin_left += 9