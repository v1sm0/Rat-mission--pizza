extends Node2D

@export var player_scene: PackedScene
@onready var players = $Players
@onready var markers = $Markers
@onready var olive = $Olive
@onready var olive_sprite = $Olive/Olive

@export var level_int = 1

func _physics_process(delta):
	var time_left = int($Timer.time_left)
	$Labeltimer.set_text(str(time_left))
	
	if Game.win_condition == true:
		$Olive/CatchedOlive.show()
		olive_sprite.hide()
		$OpenDoor.show()
		$OpenDoor/Sprite2D.show()
		$ClosedDoor.hide()
		
		if level_int >= Game.current_level:
			Game.current_level += 1
		
		
		
func _ready():
	
	var tileMaps: Array = [$TileMap2, $TileMap3, $TileMap4, $TileMap5]
	
	#$TileMap2.hide()
	#$TileMap3.hide()
	#$TileMap4.hide()
	#$TileMap5.hide()
	
	$Timer.start()
	
	Game.win_condition = false
	
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
		
		for k in range(2,6):
			#if numero de jugador pasa a la leyer que le corresponde
			if player.get_collision_layer_value(k):
				var bit = _encontrar_bit(k)
				var tile_actual = tileMaps[i]
				_color(k,tile_actual)
				tile_actual.tile_set.set_physics_layer_collision_layer(0,bit)
				
				if Game.players.size() == 1:
					print("hola")
					for j in range(1,4):
						tile_actual = tileMaps[j]
						_color(k,tile_actual)
						tile_actual.tile_set.set_physics_layer_collision_layer(0,bit)
				if Game.players.size() == 2:
					tile_actual = tileMaps[i+2]
					_color(k,tile_actual)
					tile_actual.tile_set.set_physics_layer_collision_layer(0,bit)
				if Game.players.size() == 3 && i == 0:
					tile_actual = tileMaps[i+3]
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
