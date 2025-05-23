class_name PlayerMovementComponent
extends Node

@export_category("Entity")
@export var entity: Node3D

@export_category("Speed Factors")
@export var walk_speed_factor: float = 1.0
@export var sprint_speed_factor: float = 1.5

@export_category("Gravity Factors")
@export var jump_height: float = 5.0
@export var time_to_peak: float = 0.4
@export var time_to_descent: float = 0.3

var jump_velocity: float = (2.0 * jump_height) / time_to_peak
var jump_gravity: float = (-2.0 * jump_height) / (time_to_peak * time_to_peak)
var fall_gravity: float = (-2.0 * jump_height) / (time_to_descent * time_to_descent)

var jump_available: bool = true


func get_player_input_dir() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")


func get_player_direction() -> Vector3:
	var input_dir: Vector2 = get_player_input_dir()
	return entity.transform.basis * (Vector3(input_dir.x, 0, input_dir.y)).normalized()


func get_jump_velocity() -> float:
	return jump_velocity if Input.is_action_just_pressed("jump") else 0.0


func get_gravity(velocity: Vector3) -> float:
	return jump_gravity if velocity.y > 0 else fall_gravity
