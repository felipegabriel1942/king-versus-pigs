extends CharacterBody2D

class_name Player

@export var speed = 100

@onready var animated_sprite_2d = $AnimatedSprite2D

var is_attacking = false
var direction = 0

func _physics_process(delta):
	_handle_input()
	_handle_movement()
	_handle_attack()
	_update_animation()

func _handle_input():
	direction = Input.get_axis("move_left", "move_right")

func _handle_movement():
	if not is_attacking:
		velocity.x = direction * speed
		move_and_slide()

func _handle_attack():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		_play_animation("attack")

func _update_animation():
	if is_attacking:
		return
	
	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0
		_play_animation("run")
	else:
		_play_animation("idle")

func _play_animation(name: String):
	if animated_sprite_2d.animation != name:
		animated_sprite_2d.play(name)

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "attack":
		is_attacking = false
