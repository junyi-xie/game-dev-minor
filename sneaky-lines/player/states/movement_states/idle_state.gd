extends BasePlayerMovementState


func enter(prev_state: BasePlayerMovementState, _information: Dictionary = {}) -> void:
	super(prev_state)

	animation_tree.get("parameters/MovementStateMachine/playback").travel(self.name)

	player.velocity.x = 0
	player.velocity.z = 0


func input(_event: InputEvent) -> void:
	if not player.is_on_floor():
		return

	if get_jump_velocity() > 0:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.JUMP_STATE, {"from_ground": true})
		return

	if get_player_direction() == Vector3.ZERO:
		return

	if is_sprinting():
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.SPRINT_STATE, {})
		return

	SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.WALK_STATE, {})


func physics_process(delta: float) -> void:
	apply_gravity(delta)

	if not player.is_on_floor():
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.FALL_STATE, {"coyote_time": true})
		return

	player.move_and_slide()
