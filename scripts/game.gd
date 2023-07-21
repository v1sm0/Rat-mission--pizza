extends Node

signal players_updated
signal player_updated(id)

# [ {id: int, name: string, color: string} ]
var players: Array[PlayerData] = []

@export var characters : Dictionary = {}

# [player character]
var player_character: Array = []

# Level
var level_Number = 1

# Number of players in a game
var N_players = 0

# Condition to open the doors
var win_condition = false

# Contador de botones activados
var buttton_counter = 0

# Máximo de botones
var button_max = 0

# Door condition
var door_condition = 0

# current_level usado para el menu de seleccion
var current_level = 1:
	get:
		return current_level
	set(value):
		current_level = value

# Emitted when UPnP port mapping setup is completed (regardless of success or failure).
signal upnp_completed(error)

# Replace this with your own server port number between 1024 and 65535.
const SERVER_PORT = 5409
var thread = null

func add_player(player: PlayerData) -> void:
	players.append(player)
	players_updated.emit()


func remove_player(id: int) -> void:
	for i in players.size():
		if players[i].id == id:
			players.remove_at(i)
			break
	players_updated.emit()


func get_player(id: int) -> PlayerData:
	for player in players:
		if player.id == id:
			return player
	return null

func get_player_scene(character: String) -> PackedScene:
	return characters[character]

func get_current_player() -> PlayerData:
	return get_player(multiplayer.get_unique_id())


@rpc("any_peer", "reliable", "call_local")
func set_player_color(id: int, color: String) -> void:
	var player = get_player(id)
	player.color = color
	player_updated.emit(id)


func set_current_player_color(color: String) -> void:
	set_player_color.rpc(multiplayer.get_unique_id(), color)

func _upnp_setup(server_port):
	# UPNP queries take some time.
	var upnp = UPNP.new()
	var err = upnp.discover()
	
	print("discover")
	

	if err != OK:
		push_error(str(err))
		emit_signal("upnp_completed", err)
		return

	var gateway = upnp.get_gateway()
	if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "UDP")
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "TCP")
		print("signal2")
		emit_signal("upnp_completed", OK)

func _ready():
	thread = Thread.new()
	thread.start(_upnp_setup.bind(SERVER_PORT))
	print("start")

func _exit_tree():
	# Wait for thread finish here to handle game exit while the thread is running.
	thread.wait_to_finish()
	
class PlayerData:
	var id: int
	var name: String
	var color: String

	func _init(new_id: int, new_name: String, new_color: String = "giuseppe") -> void:
		id = new_id
		name = new_name
		color = new_color

	func to_dict() -> Dictionary:
		return {
			"id": id,
			"name": name,
			"color": color
		}
