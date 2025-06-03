extends CharacterBody2D

@onready var timer = $Timer
@onready var animated_sprite_2d = $AnimatedSprite2D

var shoot_time = 0.4
var is_shooting = false

func _ready():
	timer.connect("timeout", _handle_attack)
	
func _physics_process(delta):
	_handle_animation()
	
func _handle_animation():
	if is_shooting:
		animated_sprite_2d.play("shoot")
	else:
		animated_sprite_2d.play("idle")

func _handle_attack():
	is_shooting = true
	await get_tree().create_timer(shoot_time).timeout
	is_shooting = false
	pass
