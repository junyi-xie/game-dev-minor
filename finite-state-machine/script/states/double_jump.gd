extends State

@export_category("States")
@export var fall_state: State

@export_category("Physics")
@export var jump_force: float = 450

func enter() -> void:
	super()
	parent.velocity.y = -jump_force

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	
	parent.move_and_slide()

	if parent.velocity.y > 0:
		return fall_state
	
	return null
