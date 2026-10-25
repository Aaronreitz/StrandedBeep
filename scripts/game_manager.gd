class_name GameManager
extends Node

signal all_coins_collected

const WIN_SCREEN = preload("res://scenes/win_screen.tscn")
const SAVE_PATH = "user://save.cfg"

## Key for this level's best time in the save file.
@export var level_id := "level_1"
## Scene loaded by the win screen's "Next Level" button; empty for the last level.
@export_file("*.tscn") var next_level := ""

var score = 0
var total_coins = 0
var elapsed = 0.0
var finished = false

@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	total_coins = $"../Coins".get_child_count()
	update_label()


func _process(delta: float) -> void:
	# Process is paused together with the tree, so the pause menu stops the clock.
	if not finished:
		elapsed += delta


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
	return elapsed


func level_complete():
	finished = true
	var best_time = load_best_time(level_id)
	var is_record = best_time <= 0.0 or elapsed < best_time
	if is_record:
		save_best_time(level_id, elapsed)

	var win_screen = WIN_SCREEN.instantiate()
	win_screen.total_coins = total_coins
	win_screen.elapsed = elapsed
	win_screen.best_time = elapsed if is_record else best_time
	win_screen.is_record = is_record
	win_screen.next_level = next_level
	add_child(win_screen)


static func load_best_time(level: String) -> float:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return 0.0
	return float(config.get_value(level, "best_time", 0.0))


static func save_best_time(level: String, time: float) -> void:
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value(level, "best_time", time)
	config.save(SAVE_PATH)


static func format_time(time: float) -> String:
	return "%02d:%04.1f" % [int(time) / 60, fmod(time, 60.0)]
