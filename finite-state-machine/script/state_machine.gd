extends Node

@export_category("States")
@export var default_state: State

var current_state: State

signal state_changed(state_name: String)

func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent

	change_state(default_state)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	
	state_changed.emit(current_state.name)
	
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
