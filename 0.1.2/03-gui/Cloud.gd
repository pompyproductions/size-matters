extends Sprite

export (int) var cloud_texture = 0
const WIDTH = 80
const SCREEN_WIDTH = 256

# Called when the node enters the scene tree for the first time.
func _ready():
	frame = cloud_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	position.x -= 1
	if position.x == -WIDTH:
		position.x += SCREEN_WIDTH
