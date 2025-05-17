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
		_handle_knockback(delta)

func _apply_knockback():
	var direction = (global_position - healthComponent.damager_position).normalized()
	knockback_velocity = direction * knockback_strength
	is_knocked_back = true

func _handle_knockback(delta):
	if is_knocked_back:
		get_parent().velocity = knockback_velocity
		await get_tree().create_timer(knockback_duration).timeout
		is_knocked_back = false	
		get_parent().velocity = Vector2.ZERO

