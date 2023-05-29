extends Node2D

@onready var drop_box_condition = false

func _ready():
	$AnimationPlayer.play("ButtonUp")


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		drop_box_condition = true
		$AnimationPlayer.play("ButtonDown")


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		drop_box_condition = false
		$AnimationPlayer.play("ButtonUp")
