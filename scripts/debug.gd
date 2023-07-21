extends Node

@onready var canvas_layer  = CanvasLayer.new()
@onready var container = VBoxContainer.new()

func _ready() -> void:
	add_child(canvas_layer)
	canvas_layer.layer = 100
	canvas_layer.add_child(container)

func print(message: Variant) -> void:
	if not multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		print_rich("[b]%s:[/b] " % (("Server") if multiplayer.is_server() else "Client"), message)
	else:
		print(message)
	var label = Label.new()
	label.text = str(message)
	label.set("theme_override_constants/outline_size", 2)
	label.set("theme_override_colors/font_outline_color", Color.BLACK)
	container.add_child(label)
	container.move_child(label, 0)
	await get_tree().create_timer(2).timeout
	container.remove_child(label)
	label.queue_free()
