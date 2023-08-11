extends Node2D

@export var player_scene: PackedScene
@onready var players = $Players
@onready var markers = $Markers
@onready var closed_door = $ClosedDoor
@onready var open_door = $OpenDoor
@onready var cheese_catched = $Cheese/CheeseCatched
@onready var cheese = $Cheese/Cheese

func _physics_process(delta):
	var time_left = int($Timer.time_left)
	$Labeltimer.set_text(str(time_left))
	if Game.win_condition == true:
		open_door.show()
		closed_door.hide()
		cheese.hide()
		cheese_catched.show()


func _ready():
	$Timer.start()
	Game.win_condition = false
	open_door.hide()
	closed_door.show()
	cheese.show()
	cheese_catched.hide()
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

