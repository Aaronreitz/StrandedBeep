extends Control

@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/Master
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/Music
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/SFX


func _ready() -> void:
	master_slider.value = Settings.get_volume("Master")
	music_slider.value = Settings.get_volume("Music")
	sfx_slider.value = Settings.get_volume("SFX")
	master_slider.grab_focus()


func _exit_tree() -> void:
	Settings.save()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()


func _on_master_value_changed(value: float) -> void:
	Settings.set_volume("Master", value)


func _on_music_value_changed(value: float) -> void:
	Settings.set_volume("Music", value)


func _on_sfx_value_changed(value: float) -> void:
	Settings.set_volume("SFX", value)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
