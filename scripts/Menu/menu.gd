extends Control

func  _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()

func _on_host_pressed():
	pass # Replace with function body.

func _on_join_pressed():
	pass # Replace with function body.

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn") 
