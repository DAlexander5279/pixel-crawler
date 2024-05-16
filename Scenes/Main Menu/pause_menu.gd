class_name PauseMenu
extends Control

func _ready():
	get_tree().paused = true

func _on_continue_button_down():
	get_tree().paused = false
	queue_free()


func _on_quit_to_main_menu_button_down():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main Menu/main_menu.tscn")
	
