extends CharacterBody2D

@export var gravity = 600
@export var health = 2
@export var speed = 40

var is_hit = false
var is_dead = false
var knockback_velocity = Vector2.ZERO
var knockback_strength = 100.0
var is_knocked_back = false
var knockback_time = 0.2
var knockback_timer = 0.0
var player = null
var in_attack_area = false
var in_persuit_area = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _physics_process(delta):
	_apply_gravity(delta)
	_handle_movement(delta)		
	_handle_knockback(delta)
	_handle_collision()	
	_update_animation()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _handle_collision():
	if is_dead:
		collision_shape_2d.disabled = true
		
func _handle_movement(delta):
	if player != null and not is_dead and not is_hit:
		var direction = player.global_position - global_position
		
		if direction.x <= 0:
			if !in_attack_area:
				position.x -= speed * delta
			animated_sprite_2d.flip_h = false
		else:
			if !in_attack_area:
				position.x += speed * delta
			animated_sprite_2d.flip_h = true

func _handle_knockback(delta):
	if is_knocked_back:
		velocity = knockback_velocity
		move_and_slide()
		knockback_timer -= delta
		
		if knockback_timer <= 0:
			is_knocked_back = false
			velocity = Vector2.ZERO

func _update_animation():	
	if is_dead:
		animated_sprite_2d.offset.y = -4
		_play_animation("dead")
		return
	if is_hit:
		_play_animation("hit")
		return
		
	if in_persuit_area:
		_play_animation("run")
		return
		
	_play_animation("idle")

func take_damage(damage, damager_position: Vector2):
	if is_hit:
		return
	
	health -= damage
	
	_apply_knockback(damager_position)
	
	if health > 0:
		is_hit = true
		await get_tree().create_timer(0.6).timeout
		is_hit = false
	else:
		_die()

func _apply_knockback(from_position):
	var direction = (global_position - from_position).normalized()
	knockback_velocity = direction * knockback_strength
	is_knocked_back = true
	knockback_timer = knockback_time

func _die():
	is_dead = true
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _play_animation(animation_name):
	if animated_sprite_2d.animation != animation_name:
		animated_sprite_2d.play(animation_name)

func _on_persuit_area_body_entered(body):
	player = body
	in_persuit_area = true

func _on_persuit_area_body_exited(body):
	in_persuit_area = false
	player = null

func _on_attack_area_body_entered(body):
	in_attack_area = true
	in_persuit_area = false

func _on_attack_area_body_exited(body):
	in_attack_area = false
	in_persuit_area = true
