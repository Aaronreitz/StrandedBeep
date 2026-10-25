extends CanvasLayer

var total_coins := 0
var elapsed := 0.0
var best_time := 0.0
var is_record := false

@onready var root: Control = $Root
@onready var stats_label: Label = %StatsLabel
@onready var record_label: Label = %RecordLabel
@onready var play_again: Button = %PlayAgain


func _ready() -> void:
	get_tree().paused = true
	stats_label.text = "%d / %d coins  -  %s" % [total_coins, total_coins, GameManager.format_time(elapsed)]
	if is_record:
		record_label.text = "NEW RECORD!"
		var pulse := create_tween().set_loops()
		pulse.tween_property(record_label, "modulate:a", 0.4, 0.4)
		pulse.tween_property(record_label, "modulate:a", 1.0, 0.4)
	else:
		record_label.text = "Best: " + GameManager.format_time(best_time)
	root.modulate.a = 0.0
	create_tween().tween_property(root, "modulate:a", 1.0, 0.5)
	play_again.grab_focus()


func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
