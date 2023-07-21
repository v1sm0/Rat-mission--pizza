extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.current_level == 2:
		$TileMap2.show()
	if Game.current_level == 3:
		$TileMap3.show()



