extends Area2D


func _on_body_entered(body):
	if body is CharacterBody2D:
		Game.door_condition += 1 
		print(Game.door_condition)

func _on_body_exited(body):
	if body is CharacterBody2D:
		print(Game.door_condition)
		Game.door_condition -= 1

#func _on_area_2d_2_body_entered(body):
#	if body is CharacterBody2D:
#		get_tree().reload_current_scene()

func _physics_process(delta):
	if Game.door_condition == Game.N_players && Game.win_condition == true:
		Game.level_Number += 1 
		var level_directory = "res://scenes/niveles/nivel%d.tscn" % Game.level_Number
		#cambiar el level_Number == 5 por otro numero cuando se agreguen los otros
		if Game.level_Number == 3 || Game.level_Number == 4:
			get_tree().change_scene_to_file("res://scenes/menus/selector_niveles.tscn")
		elif Game.level_Number == 5:
			get_tree().change_scene_to_file("res://scenes/menus/Win.tscn")
		else:
			get_tree().change_scene_to_file(level_directory) 
			Game.win_condition = false
			Game.door_condition = 0
