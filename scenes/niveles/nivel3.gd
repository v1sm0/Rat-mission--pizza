extends Node2D

@export var player_scene: PackedScene
@onready var players = $Players
@onready var markers = $Markers
@onready var closed_door = $ClosedDoor
@onready var open_door = $OpenDoor
@onready var tile_map_4 = $TileMap4
@onready var tile_map_5 = $TileMap5
@onready var drop_box_button = $DropBoxButton
@onready var catched_pepperoni = $TileMap4/Pepperoni/CatchedPepperoni
@onready var pepperoni = $TileMap4/Pepperoni/Pepperoni

func _physics_process(delta):
	if Game.win_condition == true:
		catched_pepperoni.show()
		pepperoni.hide()
	if Game.buttton_counter == Game.button_max:
		tile_map_4.show()
	elif drop_box_button.drop_box_condition == true:
		tile_map_5.show()
	elif Game.win_condition == true && Game.buttton_counter == Game.button_max:
		open_door.show()
		closed_door.hide()
	else:
		tile_map_5.show()
		tile_map_4.hide()
		open_door.hide()
		closed_door.show()

func _ready():
	Game.door_condition = 0
	Game.buttton_counter = 0
	Game.button_max = 2
	Game.win_condition = false
	open_door.hide()
	closed_door.show()
	Game.players.sort()
	for i in Game.players.size():
		var id = Game.players[i]
		var player: Player = player_scene.instantiate()
		players.add_child(player)
		#player.name = str(id)
		var marker = markers.get_child(i)
		player.global_position = marker.global_position
		player.scale.x = -2
		player.scale.y = 2
		player.init(id)
