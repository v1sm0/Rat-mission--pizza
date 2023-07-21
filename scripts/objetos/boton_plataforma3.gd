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
		$AnimationPlayer.play("ButtonUp")
