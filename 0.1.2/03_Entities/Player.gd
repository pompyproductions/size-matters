extends Character

# signals
signal move
signal activated

# pointers
onready var tween = $Tween
onready var timer = $Timer

# states
var is_active := false
var current_target
