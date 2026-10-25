extends Node

const SETTINGS_PATH = "user://settings.cfg"
const BUSES = ["Master", "Music", "SFX"]


func _ready() -> void:
	var config = ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	for bus_name in BUSES:
		if config.has_section_key("audio", bus_name):
			_apply_volume(bus_name, float(config.get_value("audio", bus_name)))


# Volumes are linear (0..1), the AudioServer works in dB.
func get_volume(bus_name: String) -> float:
	var bus := AudioServer.get_bus_index(bus_name)
	if AudioServer.is_bus_mute(bus):
		return 0.0
	return db_to_linear(AudioServer.get_bus_volume_db(bus))


func set_volume(bus_name: String, value: float) -> void:
	_apply_volume(bus_name, value)


func save() -> void:
	var config = ConfigFile.new()
	config.load(SETTINGS_PATH)
	for bus_name in BUSES:
		config.set_value("audio", bus_name, get_volume(bus_name))
	config.save(SETTINGS_PATH)


func _apply_volume(bus_name: String, value: float) -> void:
	var bus := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, value <= 0.0)
