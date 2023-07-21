extends Node2D

@export var player_scene: PackedScene
@onready var players = $Players
@onready var markers = $Markers
@onready var closed_door = $ClosedDoor
@onready var open_door = $OpenDoor
@onready var bacon_catched = $Bacon/BaconCatched
@onready var bacon = $Bacon/Bacon
@onready var grupo : String
#despues eliminar y mover al nivel 4 cuando este funcione
@export var level_int = 1

func _physics_process(delta):
	var time_left = int($Timer.time_left)
	$Labeltimer.set_text(str(time_left))
	if Game.win_condition == true:
		open_door.show()
		closed_door.hide()
		bacon.hide()
		bacon_catched.show()
		#despues eliminar y mover al nivel 4 cuando este funcione
		if level_int >= Game.current_level:
			Game.current_level += 1

func _ready():
	$Timer.start()
	Game.door_condition = 0
	Game.win_condition = false
	open_door.hide()
	closed_door.show()
	Game.players.sort_custom(func(a, b): return a.id > b.id)
	bacon.show()
	bacon_catched.hide()

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
		
		print(i)
		print("el valor de i es dasdawdasdasduyfawyudfawud9fa9twddfa9dfaydfgaw0wydgawydgayudgawy0dfaytdyfadywgtadyafd")
		if i == Game.players.size()-1:
			print(i)
			for k in range(2,6):
			#if numero de jugador pasa a la leyer que le corresponde
				if player.get_collision_layer_value(k):
					print(k)
					var texture
					if k == 2:
						texture = $Gris.texture
						_change_texture(texture)
						grupo = "Gris"
					if k == 3:
						texture = $Azul.texture
						_change_texture(texture)
						grupo = "Azul"
					if k == 4:
						texture = $Negro.texture
						_change_texture(texture)
						grupo = "Negro"
					if k == 5:
						texture = $Cafe.texture
						_change_texture(texture)
						grupo = "Cafe"
					


func _on_timer_timeout():
	get_tree().reload_current_scene()


func _change_texture(texture):
	var NodosHijos = $"caja-gris".get_children()
	var sprite_caja = NodosHijos[0].get_child(0)
	sprite_caja.set_texture(texture)
