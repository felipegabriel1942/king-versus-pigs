extends Node2D
class_name Heart

@onready var animated_sprite_2d = $AnimatedSprite2D

func die():
	animated_sprite_2d.play("die")
	await get_tree().create_timer(0.2).timeout
	visible = false
