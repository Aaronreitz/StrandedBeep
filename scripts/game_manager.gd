extends Node

signal all_coins_collected

const WIN_SCREEN = preload("res://scenes/win_screen.tscn")

var score = 0
var total_coins = 0
var start_time = 0

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


func level_complete():
	var win_screen = WIN_SCREEN.instantiate()
	win_screen.total_coins = total_coins
	win_screen.elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
	add_child(win_screen)
