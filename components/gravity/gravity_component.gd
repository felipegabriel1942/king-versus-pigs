extends Node2D
class_name GravityComponent

@export var gravity = 600

func _process(delta):
	if not get_parent().is_on_floor():
		get_parent().velocity.y += gravity * delta
