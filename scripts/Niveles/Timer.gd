extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	if (Game.level_Number == 1):
		set_wait_time(100)
	if (Game.level_Number == 2):
		set_wait_time(200)
	if (Game.level_Number == 3):
		set_wait_time(300)
	if (Game.level_Number == 4):
		set_wait_time(400)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
