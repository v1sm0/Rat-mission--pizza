extends Node2D

var max_players = 1
var active_players = 0 

func _ready():
	$AnimationPlayer.play("ButtonUp")


func _on_area_2d_body_entered(body):
	if body.is_in_group("CajaCantidad"):
		Game.buttton_counter += 1
		$AnimationPlayer.play("ButtonDown")
			
	if body.is_in_group("Player") && active_players <= max_players:
		Game.buttton_counter += 1
		active_players += 1	
		$AnimationPlayer.play("ButtonDown")


func _on_area_2d_body_exited(body):
	if body.is_in_group("CajaCantidad"):
		Game.buttton_counter -= 1
		$AnimationPlayer.play("ButtonDown")
			
	if body.is_in_group("Player"):
		Game.buttton_counter -= 1
		active_players -= 1	
		$AnimationPlayer.play("ButtonUp")
