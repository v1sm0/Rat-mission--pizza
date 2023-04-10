extends MarginContainer

const MAX_Player = 2
const PORT = 3002

@onready var nameInput = %NameInput
@onready var ipInput = %IPInput
@onready var host = %Host
@onready var join = %Join
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
	pass

func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	print("host")
	
func _on_join_pressed() -> void:
	print("join")

func _on_connected_to_server() -> void:
	pass
	
func _on_connection_failed() -> void:
	pass

func _on_peer_connected() -> void:
	pass
	
func _on_peer_disconnected() -> void:
	pass
	
func _on_server_disconnected() -> void:
	pass
