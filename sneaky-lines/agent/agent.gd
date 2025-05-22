class_name Agent
extends CharacterBody3D

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D


func _init() -> void:
	print("Hello")


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()


func apply_gravity(delta: float) -> void:
	velocity.y += get_gravity().y * delta
