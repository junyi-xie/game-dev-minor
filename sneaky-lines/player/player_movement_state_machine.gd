class_name MovementStateMachine
extends Node

@export var starting_state: BasePlayerMovementState
@export var player: Player
@export var movement_component: PlayerMovementComponent
@export var animation_tree: AnimationTree

var states: Dictionary[PlayerMovementEnums.PlayerMovementStates, BasePlayerMovementState] = {}

var current_state: BasePlayerMovementState
var previous_state: BasePlayerMovementState


func _ready() -> void:
	if player == null:
		push_error("%s: No player reference set." % name)

	if movement_component == null:
		push_error("%s: No movement component reference set." % name)

	if animation_tree == null:
		push_error("%s: No animation tree reference set." % name)

	SignalManager.player_transition_movement_state.connect(_transition_to_next_state)

	await owner.ready

	for state_node: BasePlayerMovementState in get_children():
		states[state_node.state_type] = state_node
		state_node.player = player
		state_node.movement_component = movement_component
		state_node.animation_tree = animation_tree

	current_state = _get_initial_state()
	current_state.enter(current_state)


func input(event: InputEvent) -> void:
	if current_state == null:
		push_error("%s: No state set." % name)
		return
	current_state.input(event)


func process(delta: float) -> void:
	if current_state == null:
		push_error("%s: No state set." % name)
		return
	current_state.process(delta)


func physics_process(delta: float) -> void:
	if current_state == null:
		push_error("%s: No state set." % name)
		return
	current_state.physics_process(delta)


func _transition_to_next_state(target_state: PlayerMovementEnums.PlayerMovementStates, info: Dictionary = {}) -> void:
	previous_state = current_state
	previous_state.exit()

	current_state = states.get(target_state)

	if not current_state:
		push_error("%s: Trying to transition to state %s, but it does not exist. Falling back to: %s" % [name, PlayerMovementEnums.PlayerMovementStates.find_key(target_state), str(previous_state)])
		current_state = previous_state

	current_state.enter(previous_state, info)


func _get_initial_state() -> BasePlayerMovementState:
	return starting_state if starting_state else get_child(0)
