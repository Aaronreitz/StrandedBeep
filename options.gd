extends Control

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)


func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
