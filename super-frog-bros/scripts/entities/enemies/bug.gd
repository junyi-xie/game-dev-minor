extends Node2D

@export var speed: float
@export var tile_size: float
@export var max_steps: int

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_left = $RayCastLeft
@onready var ray_right = $RayCastRight

var direction: int = -1
var steps_taken: float = 0

func _process(delta: float) -> void:
	position.x += speed * direction * delta
	
	if (ray_right.is_colliding() and direction == 1) or (ray_left.is_colliding() and direction == -1):
		reverse_direction()
		
	if max_steps > 0 and steps_taken >= max_steps:
		reverse_direction()
		
	steps_taken += speed * delta / tile_size
	
func reverse_direction():
	animated_sprite.flip_h = direction == -1
	direction *= -1
	steps_taken = 0
