extends BasePlayerMovementState


func enter(prev_state: BasePlayerMovementState, _info: Dictionary = {}) -> void:
	super(prev_state)

	animation_tree.get("parameters/MovementStateMachine/playback").travel(self.name)


func input(_event: InputEvent) -> void:
	if not player.is_on_floor():
		return

	if get_jump_velocity() > 0:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.JUMP_STATE, {"from_ground": true})
		return

	if is_sprinting():
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.SPRINT_STATE, {})


func physics_process(delta: float) -> void:
	apply_gravity(delta)

	var velocity: Vector3 = get_player_direction() * movement_component.walk_speed_factor

	if not player.is_on_floor():
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.FALL_STATE, {"coyote_time": true})
		return

	if velocity == Vector3.ZERO:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.IDLE_STATE, {})
		return

	apply_movement(velocity)
