extends State

@export_category("States")
@export var idle_state: State
@export var walk_state: State
@export var fall_state: State
@export var double_jump_state: State

@export_category("Physics")
@export var jump_force: float = 300

func enter() -> void:
	super()
	parent.velocity.y = -jump_force
	parent.can_double_jump = true

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.can_double_jump and parent.velocity.y < 0:
		parent.can_double_jump = false
		return double_jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	
	parent.move_and_slide()

	if parent.velocity.y > 0:
		return fall_state

	if parent.is_on_floor():
		if movement != 0:
			return walk_state
		return idle_state
	
	return null
