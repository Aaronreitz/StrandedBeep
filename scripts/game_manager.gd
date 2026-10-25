class_name GameManager
extends Node

signal all_coins_collected

const WIN_SCREEN = preload("res://scenes/win_screen.tscn")
const SAVE_PATH = "user://save.cfg"

var score = 0
var total_coins = 0
var start_time = 0
var finish_time = -1.0

@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	total_coins = $"../Coins".get_child_count()
	start_time = Time.get_ticks_msec()
	update_label()


func add_point():
	score += 1
	update_label()
	if score == total_coins:
		all_coins_collected.emit()


func update_label():
	if score >= total_coins:
		score_label.text = "All coins collected!\nFind the teleporter"
	else:
		score_label.text = "You've collected %d / %d coins" % [score, total_coins]


func elapsed_time() -> float:
	if finish_time >= 0.0:
		return finish_time
	return (Time.get_ticks_msec() - start_time) / 1000.0


func level_complete():
	finish_time = elapsed_time()
	var best_time = load_best_time()
	var is_record = best_time <= 0.0 or finish_time < best_time
	if is_record:
		save_best_time(finish_time)

	var win_screen = WIN_SCREEN.instantiate()
	win_screen.total_coins = total_coins
	win_screen.elapsed = finish_time
	win_screen.best_time = finish_time if is_record else best_time
	win_screen.is_record = is_record
	add_child(win_screen)


static func load_best_time() -> float:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return 0.0
	return float(config.get_value("level_1", "best_time", 0.0))


static func save_best_time(time: float) -> void:
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("level_1", "best_time", time)
	config.save(SAVE_PATH)


static func format_time(time: float) -> String:
	return "%02d:%04.1f" % [int(time) / 60, fmod(time, 60.0)]
