extends Area2D

var win_condition := 0

func _on_body_entered(body):
	if body is CharacterBody2D:
		win_condition += 1

func _on_body_exited(body):
	if body is CharacterBody2D:
		win_condition -= 1

func _on_area_2d_2_body_entered(body):
	if body is CharacterBody2D:
		get_tree().reload_current_scene()
		
func _physics_process(delta):
	if win_condition == 2:
		get_tree().change_scene_to_file("res://scenes/niveles/Pantalla_victoria.tscn")


