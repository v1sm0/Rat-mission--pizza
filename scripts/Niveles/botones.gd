extends Node2D


func _ready():
	$AnimationPlayer.play("ButtonUp")


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("ButtonDown")


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("ButtonUp")
