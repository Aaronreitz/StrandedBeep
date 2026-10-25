extends Control

@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/Master
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/Music
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/SFX


func _ready() -> void:
	# Sliders work in linear volume (0..1), the AudioServer in dB.
	master_slider.value = _get_bus_volume("Master")
	music_slider.value = _get_bus_volume("Music")
	sfx_slider.value = _get_bus_volume("SFX")
	master_slider.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()


func _get_bus_volume(bus_name: String) -> float:
	var bus := AudioServer.get_bus_index(bus_name)
	return db_to_linear(AudioServer.get_bus_volume_db(bus))


func _set_bus_volume(bus_name: String, value: float) -> void:
	var bus := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, value <= 0.0)


func _on_master_value_changed(value: float) -> void:
	_set_bus_volume("Master", value)


func _on_music_value_changed(value: float) -> void:
	_set_bus_volume("Music", value)


func _on_sfx_value_changed(value: float) -> void:
	_set_bus_volume("SFX", value)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
