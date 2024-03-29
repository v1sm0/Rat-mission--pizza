extends Node2D

@export var player_scene: PackedScene
@onready var players = $Players
@onready var markers = $Markers
@onready var closed_door = $ClosedDoor
@onready var open_door = $OpenDoor
@onready var tile_map_2 = $TileMap2
@onready var catched_tomato = $Tomato/CatchedTomato
@onready var tomato = $Tomato/Tomato

@export var level_int = 1

func _physics_process(delta):
	var time_left = int($Timer.time_left)
	$Labeltimer.set_text(str(time_left))
	if Game.buttton_counter == Game.button_max:
		tile_map_2.show()
	if Game.buttton_counter != Game.button_max:
		tile_map_2.hide()
	if Game.win_condition == true:
		catched_tomato.show()
		tomato.hide()
		open_door.show()
		closed_door.hide()
		if level_int >= Game.current_level:
			Game.current_level += 1

func _ready():
	$Timer.start()
	Game.win_condition = false
	Game.buttton_counter = 0
	Game.button_max = 2
	Game.door_condition = 0	
	catched_tomato.hide()
	tomato.show()
	Game.players.sort_custom(func(a, b): return a.id > b.id)
	
	for i in Game.players.size():
		var id = Game.players[i].id
#		Debug.print(Game.players[i].color)
		var player = Game.get_player_scene(Game.players[i].color).instantiate()
		players.add_child(player)
		player.name = str(id)
		var marker = markers.get_child(i)
		player.global_position = marker.global_position
		player.scale.x = -2
		player.scale.y = 2
		player.init(id)



func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/menus/Lose.tscn")
