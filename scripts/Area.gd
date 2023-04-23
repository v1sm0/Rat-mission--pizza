extends Area2D


func _on_body_entered(body):
	if body is CharacterBody2D:
		print("Ganaste :)")
		get_tree().change_scene_to_file("res://pantalla_victoria.tscn")



func _on_area_2d_2_body_entered(body):
	if body is CharacterBody2D:
		get_tree().reload_current_scene()
