extends MarginContainer

const MAX_PLAYER = 2
const PORT = 3002

@onready var nameInput = %NameInput
@onready var ipInput = %IPInput
@onready var host = %Host
@onready var join = %Join

@onready var lobby = %Lobby
@onready var readyScreen = %ReadyScreen

@onready var cancel = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer/Cancel
@onready var go = $PanelContainer/MarginContainer/ReadyScreen/HBoxContainer/Go


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
	lobby.show()
	readyScreen.hide()
	pass

func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PLAYER)
	multiplayer.multiplayer_peer = peer
	lobby.hide()
	readyScreen.show()
	print("host")
	
func _on_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ipInput.text, PORT)
	multiplayer.multiplayer_peer = peer	
	lobby.hide()
	readyScreen.show()
	print("join")

func _on_connected_to_server() -> void:
	pass
	
func _on_connection_failed() -> void:
	pass

func _on_peer_connected(id: int) -> void:
	Debug.print("peer_connected %d" % id)
	pass
	
func _on_peer_disconnected(id: int) -> void:
	Debug.print("peer_disconnected %d" % id)	
	pass
	
func _on_server_disconnected() -> void:
	pass
