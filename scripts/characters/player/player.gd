extends CharacterBody2D

class_name Player

@export var speed = 100
@export var gravity = 400

@onready var animated_sprite_2d = $AnimatedSprite2D

var is_attacking = false
var direction = 0

func _physics_process(delta):
	_apply_gravity(delta)
	_handle_input()
	_handle_movement()
	_handle_attack()
	_update_animation()

func _handle_input():
	direction = Input.get_axis("move_left", "move_right")

func _apply_gravity(delta):
		if not is_on_floor():
			velocity.y += gravity * delta

func _handle_movement():
	if not is_attacking:
		velocity.x = direction * speed
		move_and_slide()

func _handle_attack():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		_play_animation("attack")
		await get_tree().create_timer(0.3).timeout
		is_attacking = false

func _update_animation():
	if is_attacking:
		return
	
	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0
		_play_animation("run")
	else:
		_play_animation("idle")

func _play_animation(animation_name):
	if animated_sprite_2d.animation != animation_name:
		animated_sprite_2d.play(animation_name)
