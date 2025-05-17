extends Node2D
class_name HealthComponent

@export var max_health = 0
@export var time_to_queue_free = 0.0
@export var invincibility_time = 0.0

var current_health = 0
var is_hit = false
var is_dead = false
var damager_position = null

func _ready():
	current_health = max_health

func take_damage(damage, from_position: Vector2):
	if is_hit:
		return
	
	current_health -= damage
	damager_position = from_position
	
	if current_health > 0:
		is_hit = true
		await get_tree().create_timer(invincibility_time).timeout
		is_hit = false
	else:
		_die()

func _die():
	is_dead = true
	await get_tree().create_timer(time_to_queue_free).timeout
	get_parent().queue_free()
