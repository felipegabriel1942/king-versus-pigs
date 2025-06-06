extends CharacterBody2D
class_name CannonBall

@export var speed = 100
@export var damage = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hit_box = $HitBox

var is_exploding = false

func _physics_process(delta):
	_handle_movement(delta)
	
	if is_on_floor():
		_explode()
		
	move_and_slide()

func _handle_movement(delta):
	if !is_exploding:
		position.x -= speed * delta

func _on_hit_box_body_entered(body):
	if body is Player:
		body.health_component.take_damage(damage, global_position)
		_explode()

func _explode():
	is_exploding = true
	animated_sprite_2d.play("explosion")
	await get_tree().create_timer(0.5).timeout
	queue_free()
