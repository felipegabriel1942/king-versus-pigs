extends CharacterBody2D

@export var speed = 40

var player = null
var in_attack_area = false
var in_persuit_area = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var health_component = $HealthComponent

func _physics_process(delta):
	_handle_movement(delta)		
	_update_animation()
	move_and_slide()

func _handle_movement(delta):
	if player != null and not health_component.is_dead and not health_component.is_hit:
		var direction = player.global_position - global_position
		
		if direction.x <= 0:
			if !in_attack_area:
				position.x -= speed * delta
			animated_sprite_2d.flip_h = false
		else:
			if !in_attack_area:
				position.x += speed * delta
			animated_sprite_2d.flip_h = true

func _update_animation():	
	if health_component.is_dead:
		_play_animation("dead")
		return
	if health_component.is_hit:
		_play_animation("hit")
		return
		
	if in_persuit_area:
		_play_animation("run")
		return
		
	_play_animation("idle")

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
