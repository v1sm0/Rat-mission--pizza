extends Node2D

@onready var tileMap = get_parent()

func _ready():
	$AnimationPlayer.play("ButtonUp")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		tileMap.set_layer_modulate(0,Color(1,1,1))
		tileMap.tile_set.set_physics_layer_collision_layer(0,0b00000000000000000001)
		$AnimationPlayer.play("ButtonDown")

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		if body.get_collision_layer_value(2):
			tileMap.set_layer_modulate(0,Color(200,200,200))
			tileMap.tile_set.set_physics_layer_collision_layer(0,0b00000000000000000010)
		if body.get_collision_layer_value(3):
			tileMap.set_layer_modulate(0,Color(0,0,255))
			tileMap.tile_set.set_physics_layer_collision_layer(0,0b00000000000000000100)
		if body.get_collision_layer_value(4):
			tileMap.set_layer_modulate(0,Color(0,0,0))
			tileMap.tile_set.set_physics_layer_collision_layer(0,0b00000000000000001000)
		if body.get_collision_layer_value(5):
			tileMap.set_layer_modulate(0,Color(128,64,0))
			tileMap.tile_set.set_physics_layer_collision_layer(0,0b00000000000000010000)
		$AnimationPlayer.play("ButtonUp")
