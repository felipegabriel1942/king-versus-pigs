extends CharacterBody2D

class_name Player

@export var speed = 75
@export var jump_force = -200

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hitbox = $Hitbox

var is_attacking = false
var direction = 0
var hitbox_offset := Vector2.ZERO

func _ready():
	hitbox_offset = hitbox.position

func _physics_process(delta):
	_handle_input()
	_handle_movement()
	_handle_attack()
	_handle_jump()
	_update_animation()

func _handle_input():
	direction = Input.get_axis("move_left", "move_right")

func _handle_movement():
	velocity.x = direction * speed
	move_and_slide()
	
func _handle_attack():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		hitbox.monitoring = true
		
		await get_tree().create_timer(0.3).timeout
		is_attacking = false
		hitbox.monitoring = false

func _handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

func _update_animation():
	if is_attacking:
		_play_animation("attack")
		return
		
	if is_on_floor():
		if direction != 0:
			animated_sprite_2d.flip_h = direction < 0
			
			if animated_sprite_2d.flip_h:
				hitbox.position.x = -abs(hitbox.position.x)
			else:
				hitbox.position.x = abs(hitbox.position.x)
			
			_play_animation("run")
		else:
			_play_animation("idle")
	else:
		animated_sprite_2d.flip_h = direction < 0
		
		if velocity.y <= 0:
			_play_animation("jump")
		else:
			_play_animation("fall")

func _play_animation(animation_name):
	if animated_sprite_2d.animation != animation_name:
		animated_sprite_2d.play(animation_name)

func _on_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		body.health_component.take_damage(1, global_position)
