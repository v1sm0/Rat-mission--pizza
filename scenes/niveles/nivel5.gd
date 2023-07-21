extends Node2D

@export var player_scene: PackedScene
@onready var players = $Players
@onready var markers = $Markers

func _physics_process(delta):
	var time_left = int($Timer.time_left)
	$Labeltimer.set_text(str(time_left))
		
		
		
func _ready():
	
	var tileMaps: Array = [$TileMap2, $TileMap3]
	
	$TileMap2.hide()
	$TileMap3.hide()
	
	$Timer.start()
	#$TileMap2.set_collision_layer_bit(0b00000000000000000010, true)
	#var player1 = Game.players[0]
	#var layer_bit = player_scene.get_collision_layer_value(3)
	#-bits con solo 1 al fianl
	#$TileMap2.set_collision_layer_value(layer_bit, true)
	
	Game.buttton_counter = 0
	Game.button_max = 4
	Game.win_condition = false
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
		
		for k in range(2,5):
			#if numero de jugador pasa a la leyer que le corresponde
			if player.get_collision_layer_value(k):
				var bit = _encontrar_bit(k)
				var tile_actual = tileMaps[i]
				tile_actual.show()
				_color(k,tile_actual)
				tile_actual.tile_set.set_physics_layer_collision_layer(0,bit)


func _on_timer_timeout():
	pass # Replace with function body.
	

func _encontrar_bit(a):
	var bit = 0
	if a == 2:
		bit = 0b00000000000000000010
	if a == 3:
		bit = 0b00000000000000000100
	if a == 4:
		bit = 0b00000000000000001000
	if a == 5:
		bit = 0b00000000000000010000
	return bit 
	

func _color(a,b):
	if a == 2:
		b.set_layer_modulate(0,Color(200,200,200))
	if a == 3:
		b.set_layer_modulate(0,Color(0,0,255))
	if a == 4:
		b.set_layer_modulate(0,Color(0,0,0))
	if a == 5:
		b.set_layer_modulate(0,Color(128,64,0))
	return 
