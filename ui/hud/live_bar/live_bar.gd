extends Control

@onready var hearts = $Hearts

var heart_01: Node2D
var heart_02: Node2D
var heart_03: Node2D

func _ready():
	heart_01 = hearts.get_children()[0]
	heart_02 = hearts.get_children()[1]
	heart_03 = hearts.get_children()[2]

func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Player
	var player_health = player.health_component as HealthComponent
	
	if player_health.current_health == 2:
		heart_03.die()
		
	if player_health.current_health == 1:
		heart_02.die()
	
	if player_health.is_dead:
		heart_01.die()
