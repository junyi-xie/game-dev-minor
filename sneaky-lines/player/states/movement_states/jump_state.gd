extends BasePlayerMovementState

@export var air_jumps: int = 1

var _air_jumps_used: int = 0


func enter(prev_state: BasePlayerMovementState, information: Dictionary = {}) -> void:
	super(prev_state)

	if information.get("from_ground", false):
		_air_jumps_used = 0
	else:
		_air_jumps_used += 1

	movement_component.jump_available = air_jumps > _air_jumps_used

	animation_tree.get("parameters/MovementStateMachine/playback").travel(self.name)

	player.velocity.y = get_jump_velocity()


func input(_event: InputEvent) -> void:
	if get_jump_velocity() > 0 and _air_jumps_used < air_jumps:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.JUMP_STATE, {})


func physics_process(delta: float) -> void:
	apply_gravity(delta)

	if player.velocity.y < 0:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.FALL_STATE, {})
		return

	var speed_factor: float

	if is_sprinting():
		speed_factor = movement_component.sprint_speed_factor
	else:
		speed_factor = movement_component.walk_speed_factor

	var velocity: Vector3 = get_player_direction() * speed_factor

	apply_movement(velocity)

	if not player.is_on_floor():
		return

	if velocity == Vector3.ZERO:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.IDLE_STATE, {})
		return

	if is_sprinting():
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.SPRINT_STATE, {})
		return

	SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.WALK_STATE, {})
