extends CharacterBody2D

var speed = 100

func _physics_process(delta):
	_handle_movement(delta)

func _handle_movement(delta):
	position.x -= speed * delta
