extends CharacterBody2D

var health = 3
var is_hit = false
var is_dead = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _physics_process(delta):
	_handle_collision()	
	_update_animation()

func _handle_collision():
	if is_dead:
		collision_shape_2d.disabled = true

func _update_animation():
	if is_dead:
		_play_animation("dead")
		return
	if is_hit:
		_play_animation("hit")
		return
		
	_play_animation("idle")

func take_damage(damage):
	health -= damage
	
	if health > 0:
		is_hit = true
		await get_tree().create_timer(0.2).timeout
		is_hit = false
	else:
		_die()

func _die():
	is_dead = true
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _play_animation(animation_name):
	if animated_sprite_2d.animation != animation_name:
		animated_sprite_2d.play(animation_name)
