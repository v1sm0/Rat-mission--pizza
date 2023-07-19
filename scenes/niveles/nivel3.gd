extends Node2D

@export var player_scene: PackedScene
@onready var players = $Players
@onready var markers = $Markers
@onready var closed_door = $ClosedDoor
@onready var open_door = $OpenDoor
@onready var bacon_catched = $Bacon/BaconCatched
@onready var bacon = $Bacon/Bacon

func _physics_process(delta):
	var time_left = int($Timer.time_left)
	$Labeltimer.set_text(str(time_left))
	if Game.win_condition == true:
		open_door.show()
		closed_door.hide()
		bacon.hide()
		bacon_catched.show()

func _ready():
	$Timer.start()
	Game.door_condition = 0
	Game.win_condition = false
	open_door.hide()
	closed_door.show()
	bacon.show()
	bacon_catched.hide()
	Game.players.sort()
	for i in Game.players.size():
		var id = Game.players[i]
		var player: Player = player_scene.instantiate()
		players.add_child(player)
		var marker = markers.get_child(i)
		player.global_position = marker.global_position
		player.scale.x = -2
		player.scale.y = 2
		player.init(id)


func _on_timer_timeout():
	get_tree().reload_current_scene()
