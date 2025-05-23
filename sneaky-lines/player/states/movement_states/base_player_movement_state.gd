class_name BasePlayerMovementState
extends BaseState

@export var state_type: PlayerMovementEnums.PlayerMovementStates

var player: Player
var previous_state: BasePlayerMovementState
var movement_component: PlayerMovementComponent
var animation_tree: AnimationTree


func enter(prev_state: BasePlayerMovementState, _info: Dictionary = {}) -> void:
	previous_state = prev_state


func apply_gravity(delta: float) -> void:
	player.velocity.y += movement_component.get_gravity(player.velocity) * delta


func apply_movement(velocity: Vector3) -> void:
	player.velocity.x = velocity.x
	player.velocity.z = velocity.z
	player.move_and_slide()


func is_sprinting() -> bool:
	return Input.is_action_pressed("sprint")


func get_gravity(velocity: Vector3) -> float:
	return movement_component.get_gravity(velocity)


func get_jump_velocity() -> float:
	return movement_component.get_jump_velocity()


func get_player_input_dir() -> Vector2:
	return movement_component.get_player_input_dir()


func get_player_direction() -> Vector3:
	return movement_component.get_player_direction()
