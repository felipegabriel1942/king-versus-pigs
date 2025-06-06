extends CharacterBody2D

class_name Player

@export var speed = 75
@export var jump_force = -200

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var health_component = $HealthComponent

var is_attacking = false
var direction = 0

func _physics_process(delta):
	_handle_input()
	_handle_movement()
	_handle_attack()
	_handle_jump()
	_handle_animation()
	move_and_slide()

func _handle_input():
	if !health_component.is_hit:
		direction = Input.get_axis("move_left", "move_right")

func _handle_movement():
	if !health_component.is_hit and !health_component.is_dead:
		velocity.x = direction * speed
	
func _handle_attack():
	if _can_attack():
		var wait_time = 0.3
		var hitbox_collision = hitbox.get_node("CollisionShape2D")
		
		hitbox_collision.disabled = false
		is_attacking = true
		await get_tree().create_timer(wait_time).timeout
		hitbox_collision.disabled = true

func _can_attack():
	return Input.is_action_just_pressed("attack") and not is_attacking and !health_component.is_dead

func _handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor() and !health_component.is_dead:
		velocity.y = jump_force

func _handle_animation():
	if is_attacking:
		_play_animation("attack")
		return
		
	if health_component.is_hit:
		_play_animation("hit")
		return
	
	if health_component.is_dead:
		_play_animation("dead")
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

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
