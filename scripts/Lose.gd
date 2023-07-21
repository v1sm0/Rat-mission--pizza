extends Control

func  _on_restart_pressed():
	var level_directory = "res://scenes/niveles/nivel%d.tscn" % Game.level_Number
	get_tree().change_scene_to_file(level_directory)

func _on_win_restart_pressed():
	var level_directory = "res://scenes/niveles/nivel1.tscn"
	get_tree().change_scene_to_file(level_directory)
	

func _on_exit_pressed():
	get_tree().quit()

func _on_disconnect_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn") 
