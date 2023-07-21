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
@onready var caja_cantidad = $CajaCantidad
@onready var caja_cantidad_4 = $CajaCantidad4


func _physics_process(delta):
	if Game.win_condition == true:
		catched_pepperoni.show()
		pepperoni.hide()
		open_door.show()
		closed_door.hide()
	if Game.buttton_counter == Game.button_max:
		tile_map_4.show()
	if drop_box_button.drop_box_condition == true:
		tile_map_5.hide()
		caja_cantidad_4.show()
		
		
		
func _ready():
	tile_map_4.hide()
	Game.buttton_counter = 0
	Game.button_max = 4
	Game.win_condition = false
	open_door.hide()
	closed_door.show()
	Game.players.sort_custom(func(a, b): return a.id > b.id)
	
	for i in Game.players.size():
		var id = Game.players[i].id
		Debug.print(Game.players[i].color)
		var player = Game.get_player_scene(Game.players[i].color).instantiate()
		players.add_child(player)
		player.name = str(id)
		var marker = markers.get_child(i)
		player.global_position = marker.global_position
		player.scale.x = -2
		player.scale.y = 2
		player.init(id)

	
