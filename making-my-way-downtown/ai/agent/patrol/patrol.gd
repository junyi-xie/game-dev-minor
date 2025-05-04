extends Agent

var patrol_points: Array = []
var index: int = 0


func _physics_process(delta: float) -> void:
	if patrol_points.size() == 2:
		nav_agent.target_position = patrol_points[index]

		direction = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()

		velocity = velocity.lerp(direction * speed, acceleration * delta)

		if nav_agent.is_target_reached():
			index = (index + 1) % patrol_points.size()

	super._physics_process(delta)


func move_agent_to(target_position: Vector3) -> void:
	patrol_points.append(target_position)

	if patrol_points.size() > 2:
		patrol_points.remove_at(0)
