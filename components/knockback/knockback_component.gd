extends Node2D
class_name KnockbackComponent

@export var healthComponent: HealthComponent
@export var knockback_duration = 0.2
@export var knockback_strength = 100.0

var is_knocked_back = false
var knockback_velocity = Vector2.ZERO

func _process(delta):
	if healthComponent.is_hit:
		_apply_knockback()

func _apply_knockback():
	var direction = sign(global_position.x - healthComponent.damager_position.x)
	knockback_velocity = Vector2(direction * knockback_strength, 0)
	get_parent().velocity.x = direction * knockback_strength
	print(get_parent().velocity.x)
	await get_tree().create_timer(knockback_duration).timeout
	get_parent().velocity.x = 0
