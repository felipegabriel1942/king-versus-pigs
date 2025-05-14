extends CharacterBody2D

class_name Player

@export var speed = 100

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	_handle_movement()
	_update_animation()

func _handle_movement():
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	move_and_slide()

func _update_animation():
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0
		_play_animation("run")
	else:
		_play_animation("idle")

func _play_animation(name: String):
	if animated_sprite_2d.animation != name:
		animated_sprite_2d.play(name)
