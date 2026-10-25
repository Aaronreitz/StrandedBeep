extends CanvasLayer

@onready var resume_button: Button = %Resume


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
			_on_resume_pressed()
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("pause") and not get_tree().paused:
		# Don't open on top of the win screen, which pauses the tree itself.
		visible = true
		get_tree().paused = true
		resume_button.grab_focus()
		get_viewport().set_input_as_handled()


func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
