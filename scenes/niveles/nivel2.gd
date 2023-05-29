extends Node2D

@export var player_scene: PackedScene
@onready var players = $Players
@onready var markers = $Markers
@onready var closed_door = $ClosedDoor
@onready var open_door = $OpenDoor
@onready var tile_map_2 = $TileMap2
@onready var catched_tomato = $Tomato/CatchedTomato
@onready var tomato = $Tomato/Tomato

func _physics_process(delta):
	if Game.win_condition == true:
		catched_tomato.show()
		tomato.hide()
	if Game.buttton_counter == Game.button_max:
		tile_map_2.show()
	elif Game.win_condition == true && Game.buttton_counter == Game.button_max:
		open_door.show()
		closed_door.hide()
	else:
		tile_map_2.hide()
		open_door.hide()
		closed_door.show()

func _ready():
	Game.win_condition = false
	Game.buttton_counter = 0
	Game.button_max = 2
	
	catched_tomato.hide()
	tomato.show()
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

