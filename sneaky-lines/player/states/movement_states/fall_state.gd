extends BasePlayerMovementState

var _has_coyote: bool = false
var _has_initial_velocity: bool

@onready var coyote_timer: Timer = $CoyoteTimer


func enter(prev_state: BasePlayerMovementState, information: Dictionary = {}) -> void:
	super(prev_state)

	animation_tree.get("parameters/MovementStateMachine/playback").travel(self.name)

	var active_coyote_time = information.get("coyote_time", false)

	_has_initial_velocity = false

	if "initial_velocity" in information:
		player.velocity = information["initial_velocity"]
		_has_initial_velocity = true

	if active_coyote_time:
		_has_coyote = true
		coyote_timer.start(active_coyote_time)


func process(_delta: float) -> void:
	if  Input.is_action_pressed("jump") and movement_component.jump_available:
		SignalManager.player_transition_movement_state.emit(PlayerMovementEnums.PlayerMovementStates.JUMP_STATE, {})


func physics_process(delta: float) -> void:
	apply_gravity(delta)

	var speed_factor: float

	if is_sprinting():
		speed_factor = movement_component.sprint_speed_factor
	else:
		speed_factor = movement_component.walk_speed_factor

	var velocity: Vector3

	if _has_initial_velocity:
		velocity = player.velocity
	else:
		velocity = get_player_direction() * speed_factor

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


func _on_coyote_timer_timeout() -> void:
	_has_coyote = false
