extends Control

func _ready() -> void:
	# Focus is needed so the menu can be navigated with a controller.
	$VBoxContainer/Button.grab_focus()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
