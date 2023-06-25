extends MarginContainer


const MAX_PLAYERS = 4

const PORT = 5409

@onready var info = $PanelContainer/MarginContainer/Lobby/Info

@export var giovanni_scene: PackedScene
@export var giuseppe_scene: PackedScene
@export var salvatore_scene: PackedScene
@export var vito_scene: PackedScene

@onready var nameInput = %NameInput
@onready var ipInput = %IPInput
@onready var host = %Host
@onready var join = %Join	
@onready var players = %Players

@onready var lobby = %Lobby
@onready var readyScreen = %ReadyScreen
@onready var giovanni_animation = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer2/Giovanni/AnimationPlayer
@onready var giuseppe_animation = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer2/Giuseppe/AnimationPlayer
@onready var salvatore_animation = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer2/salvatore/AnimationPlayer	
@onready var vitoa_animation= $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer2/Vito/AnimationPlayer
@onready var cancel = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer/Cancel
@onready var go = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer/Go

@onready var giovanni = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer2/Giovanni
@onready var giuseppe = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer2/Giuseppe
@onready var salvatore = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer2/salvatore
@onready var vito = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer2/Vito

var status = { 1 : false }
# Called when the node enters the scene tree for the first time.
func _ready():
	# nameInput.text
	host.pressed.connect(_on_host_pressed)
	join.pressed.connect(_on_join_pressed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	giovanni.pressed.connect(_on_giovanni_selected)
	giuseppe.pressed.connect(_on_giuseppe_selected)
	salvatore.pressed.connect(_on_salvatore_selected)
	vito.pressed.connect(_on_vito_selected)
	
	
	lobby.show()
	readyScreen.hide()
	giovanni_animation.play("IDLE")
	giuseppe_animation.play("IDLE")
	salvatore_animation.play("IDLE")
	vitoa_animation.play("IDLE")
	nameInput.text = OS.get_environment("USERNAME")
	
	go.pressed.connect(_on_go_pressed)
	
#	info.hide()
	
	Game.upnp_completed.connect(_on_upunp_completed)

func _on_giovanni_selected() -> void:
	print("escogí a giovanni")
	var new_giovanni: Player = giovanni_scene.instantiate()
	Game.player_character.append(new_giovanni)
	
	print(Game.player_character)
	
func _on_giuseppe_selected() -> void:
	var new_giuseppe: Player = giovanni_scene.instantiate()
	Game.player_character.append(new_giuseppe)

func _on_salvatore_selected() -> void:
	var new_salvatore: Player = salvatore_scene.instantiate()
	Game.player_character.append(new_salvatore)

func _on_vito_selected() -> void:
	var new_vito: Player = vito_scene.instantiate()
	Game.player_character.append(new_vito)
	
func _on_upunp_completed(status) -> void:
	print(status)
	if status == OK:
		info.text = "Port Opened"
	else:
		info.text = "Error"
	info.show()

func _on_host_pressed() -> void:
	Debug.print("host")
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PORT, MAX_PLAYERS)
	print(err)
	multiplayer.multiplayer_peer = peer
	lobby.hide()
	_add_player(nameInput.text, multiplayer.get_unique_id())
	readyScreen.show()
	
func _on_join_pressed() -> void:
	Debug.print("join")
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ipInput.text, PORT)
	print(err)
	multiplayer.multiplayer_peer = peer
	lobby.hide()
	_add_player(nameInput.text, multiplayer.get_unique_id())
	readyScreen.show()

func _add_player(name: String, id: int):
	var label = Label.new()
	label.name = str(id)
	label.text = name
	players.add_child(label)
	Game.players.append(id)
	Game.N_players += 1

@rpc("any_peer", "reliable")
func send_info(info: Dictionary) -> void:
	var name = info.name
	var id = multiplayer.get_remote_sender_id()
	_add_player(name, id)

func _on_connected_to_server() -> void:
	Debug.print("connected_to_server")
	
func _on_connection_failed() -> void:
	Debug.print("connection_failed")

func _on_peer_connected(id: int) -> void:
	Debug.print("peer_connected %d" % id)
	rpc_id(id, "send_info", { "name": nameInput.text })
	if multiplayer.is_server():
		status[id] = false
	
func _on_peer_disconnected(id: int) -> void:
	Debug.print("peer_disconnected %d" % id)	
		
func _on_server_disconnected() -> void:
	print("server_disconnected")

func _paint_ready(id: int) -> void:
	for child in players.get_children():
		if child.name == str(id):
			child.modulate = Color.GREEN_YELLOW

func _on_go_pressed() -> void:
	rpc("player_ready")
	_paint_ready(multiplayer.get_unique_id())

@rpc("reliable", "any_peer", "call_local")
func player_ready():
	var id = multiplayer.get_remote_sender_id()
	_paint_ready(id)
	if multiplayer.is_server():
		status[id] = true
		var all_ok = true
		for ok in status.values():
			all_ok = all_ok and ok
		if all_ok and (Game.player_character.size() == Game.players.size()):
			rpc("start_game")

@rpc("any_peer", "call_local", "reliable")
func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/niveles/nivel1.tscn")
	
