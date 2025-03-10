extends State

@export_category("States")
@export var idle_state: State
@export var walk_state: State
@export var double_jump_state: State

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.is_on_floor():
		parent.can_double_jump = true
	
	var movement = Input.get_axis("move_left", "move_right") * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if Input.is_action_just_pressed("jump") and not parent.is_on_floor() and parent.can_double_jump:
		parent.can_double_jump = false
		return double_jump_state
	
	if parent.is_on_floor():
		if movement != 0:
			return walk_state
		return idle_state
		
	return null
