extends CharacterBody2D

@onready var timer = $Timer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle = $Muzzle

var cannon_ball = preload("res://characters/enemies/cannon/cannon_ball.tscn")

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
	var cannon_ball_instance = cannon_ball.instantiate()
	cannon_ball_instance.global_position = muzzle.global_position
	get_tree().current_scene.add_child(cannon_ball_instance)
	await get_tree().create_timer(shoot_time).timeout
	is_shooting = false
	pass
