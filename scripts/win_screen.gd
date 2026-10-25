extends CanvasLayer

var total_coins := 0
var elapsed := 0.0

@onready var root: Control = $Root
@onready var stats_label: Label = %StatsLabel
@onready var play_again: Button = %PlayAgain


func _ready() -> void:
	get_tree().paused = true
	stats_label.text = "%d / %d coins  -  %.1f s" % [total_coins, total_coins, elapsed]
	root.modulate.a = 0.0
	create_tween().tween_property(root, "modulate:a", 1.0, 0.5)
	play_again.grab_focus()


func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
