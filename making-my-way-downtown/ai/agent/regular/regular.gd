extends Agent

var direction: Vector3
var next_position: Vector3


func _physics_process(delta: float) -> void:
	nav_agent.target_position = next_position

	direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, acceleration * delta)

	super._physics_process(delta)


func move_agent_to(target_position: Vector3) -> void:
	next_position = target_position
