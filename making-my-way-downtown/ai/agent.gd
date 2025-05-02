class_name Agent
extends CharacterBody3D

@export var speed = 10
@export var accel = 15

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var target: Marker3D = $"../Marker3D"


func _physics_process(delta):
	var direction = Vector3()

	nav.target_position = target.global_position

	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)

	move_and_slide()
