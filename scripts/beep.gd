extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var controllable := true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_sound: AudioStreamPlayer = $HurtSound


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not controllable:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("move")
	else:
		animated_sprite.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func die() -> void:
	if not controllable:
		return
	controllable = false
	animated_sprite.play("death")
	hurt_sound.play()
	# Small hop, then fall through the level.
	velocity = Vector2(0, JUMP_VELOCITY * 0.5)
	$CollisionShape2D.queue_free()
	_shake_camera()


func _shake_camera() -> void:
	# The camera lives in the level scene, so it may be missing.
	var camera := get_node_or_null("Camera2D") as Camera2D
	if camera == null:
		return
	var tween := create_tween()
	for i in 6:
		tween.tween_property(camera, "offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)), 0.04)
	tween.tween_property(camera, "offset", Vector2.ZERO, 0.04)


func teleport_out(target_x: float) -> void:
	controllable = false
	set_physics_process(false)
	velocity = Vector2.ZERO
	animated_sprite.play("idle")
	var tween := create_tween()
	tween.tween_property(self, "global_position:x", target_x, 0.15)
	tween.tween_property(animated_sprite, "scale", Vector2(0.3, 1.6), 0.25)
	tween.parallel().tween_property(self, "modulate", Color(0.4, 1.0, 1.0, 0.0), 0.35)
	await tween.finished
