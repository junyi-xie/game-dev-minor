extends BasePlayerMovementState


func enter(prev_state: BasePlayerMovementState, _information: Dictionary = {}) -> void:
	super(prev_state)

	animation_tree.get("parameters/MovementStateMachine/playback").travel(self.name)


func input(_event: InputEvent) -> void:
	if not player.is_on_floor():
		return

	if get_jump_velocity() > 0:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.JUMP_STATE, {"from_ground": true})
		return


func process(_delta: float) -> void:
	if not Input.is_action_pressed("sprint"):
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.WALK_STATE, {})
		return


func physics_process(delta: float) -> void:
	apply_gravity(delta)

	var velocity = get_player_direction() * movement_component.sprint_speed_factor

	if not player.is_on_floor():
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.FALL_STATE, {"coyote_time": true})
		return

	if velocity == Vector3.ZERO:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.IDLE_STATE, {})
		return

	apply_movement(velocity)
