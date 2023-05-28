extends Area2D


func _on_body_entered(body):
	if body is CharacterBody2D:
		Game.win_condition = true
		

#func _on_body_exited(body):
#	if body is CharacterBody2D:
#		win_condition -= 1

#func _on_area_2d_2_body_entered(body):
#	if body is CharacterBody2D:
#		get_tree().reload_current_scene()

#func _physics_process(delta):
#	if Game.win_condition == true:
#		print("Ya agarré la comida")
#		open_door.hide()
#		closed_door.show()
#


