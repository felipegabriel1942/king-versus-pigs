extends CharacterBody2D

@export var speed = 40
@export var has_knockback = true

var player: Player = null
var in_attack_area = false
var in_persuit_area = false
var is_attacking = false
var time_between_attacks = 3
var attack_cooldown = false
var is_lighting_match = false
var is_match_on = false
var is_lighting_cannon = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var health_component = $HealthComponent
@onready var attack_timer = $AttackTimer

var knockback_component = preload("res://components/knockback/knockback_component.tscn") 

func _ready():
	attack_timer.connect("timeout", _handle_attack)
	
	if has_knockback:
		var knockback_component_instance = knockback_component.instantiate()
		knockback_component_instance.healthComponent = health_component
		self.add_child(knockback_component_instance)

func _physics_process(delta):
	_handle_death()
	_handle_movement(delta)
	_handle_animation()
	move_and_slide()

func _handle_movement(delta):
	if _can_move():
		var direction = player.global_position - global_position
		
		if direction.x <= 0:
			if !in_attack_area:
				position.x -= speed * delta
			animated_sprite_2d.flip_h = false
		else:
			if !in_attack_area:
				position.x += speed * delta
			animated_sprite_2d.flip_h = true

func _can_move():
	return player != null and not health_component.is_dead and not health_component.is_hit;

func _handle_attack():
	if _can_attack():
		is_attacking = true
		attack_cooldown = true
		
		if player != null:
			player.health_component.take_damage(1, global_position)
			
		await get_tree().create_timer(time_between_attacks).timeout
		attack_cooldown = false

func _can_attack():
	return in_attack_area and !is_attacking and !attack_cooldown and !health_component.is_dead and !player.health_component.is_dead;

func _handle_animation():	
	if health_component.is_dead:
		_play_animation("dead")
		return
		
	if health_component.is_hit:
		_play_animation("hit")
		return
		
	if in_persuit_area and not is_attacking and speed > 0:
		_play_animation("run")
		return
		
	if is_attacking:
		_play_animation("attack")
		return
		
	if is_lighting_match:
		_play_animation("lighting_match")
		return
		
	if is_match_on:
		_play_animation("match_on")
		return
	
	if is_lighting_cannon:
		_play_animation("lighting_cannon")
		return
			
	_play_animation("idle")

func _play_animation(animation_name):
	if animated_sprite_2d.animation != animation_name:
		animated_sprite_2d.play(animation_name)

func _on_persuit_area_body_entered(body: CharacterBody2D):
	if body is Player:
		player = body
		in_persuit_area = true

func _on_persuit_area_body_exited(body: CharacterBody2D):
	in_persuit_area = false
	player = null

func _on_attack_area_body_entered(body: CharacterBody2D):
	in_attack_area = true
	in_persuit_area = false
	attack_timer.start()

func _on_attack_area_body_exited(body: CharacterBody2D):
	in_attack_area = false
	in_persuit_area = true
	attack_timer.stop()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "attack":
		is_attacking = false

func _handle_death():
	if health_component.is_dead:
		set_collision_mask_value(1, false)
		set_collision_layer_value(2, false)
