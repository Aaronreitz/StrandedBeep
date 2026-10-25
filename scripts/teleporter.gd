extends Area2D

const BEAM_HEIGHT = 40.0
const COLOR_BASE = Color("3d3f5c")
const COLOR_TOP = Color("8c8fb3")
const COLOR_OFF = Color("c0392b")
const COLOR_ON = Color("5ff3ff")

var active := false
var used := false
var time := 0.0

@onready var game_manager: Node = %GameManager
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var activate_sound: AudioStreamPlayer2D = $ActivateSound


func _ready() -> void:
	game_manager.all_coins_collected.connect(activate)


func _process(delta: float) -> void:
	if active:
		time += delta
		queue_redraw()


func activate() -> void:
	active = true
	particles.emitting = true
	activate_sound.play()
	# Beep may already be standing on the pad.
	for body in get_overlapping_bodies():
		_on_body_entered(body)


func _draw() -> void:
	var light := COLOR_ON if active else COLOR_OFF
	if active:
		var pulse := 0.35 + 0.15 * sin(time * 5.0)
		draw_rect(Rect2(-8, -6 - BEAM_HEIGHT, 16, BEAM_HEIGHT), Color(COLOR_ON, pulse))
		draw_rect(Rect2(-4, -6 - BEAM_HEIGHT, 8, BEAM_HEIGHT), Color(COLOR_ON, pulse + 0.2))
	draw_rect(Rect2(-12, -4, 24, 4), COLOR_BASE)
	draw_rect(Rect2(-10, -6, 20, 2), COLOR_TOP)
	draw_rect(Rect2(-12, -6, 2, 2), light)
	draw_rect(Rect2(10, -6, 2, 2), light)


func _on_body_entered(body: Node2D) -> void:
	if not active or used or not body.has_method("teleport_out"):
		return
	used = true
	await body.teleport_out(global_position.x)
	game_manager.level_complete()
