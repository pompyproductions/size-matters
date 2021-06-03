extends Camera2D

var input_dir = Vector2.ZERO
var node_tween

func _ready():
	node_tween = $Tween

func move(dir):
	var dist
	if dir in [1, -1]:
		dist = 10 * 8
	node_tween.interpolate_property(self, "position", 
	position, position + Vector2(dist * dir, 0), 
	1.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	node_tween.start()

func change_dir(dir):
	var dist = 14 * 8
	node_tween.interpolate_property(self, "position", 
	position, position + Vector2(dist * dir, 0), 
	1.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	node_tween.start()
