@tool 
extends BTAction

## Blackboard variable that stores  the agent's target position.
@export var target_position_var: StringName = &"target_position"
## Blackboard variable that stores a list of patrol points.
@export var patrol_points_var: StringName = &"patrol_points"
## The minimum distance to the target at which the agent considers the position reached and returns SUCCESS.
@export var tolerance: float = 2.0
## If true, the agent will patrol continuously between all patrol points in a loop.
@export var patrol: bool = true
## The rotation speed of the agent (radians/sec).
@export var rotation_speed: float = 6.0
## If true, the agent will face away from its movement direction instead of towards it.
@export var face_away: bool = false

var _target_position: Vector3


func _generate_name() -> String:
	return "Move to Position ➜ %s" % [LimboUtility.decorate_var(target_position_var)]


func _enter() -> void:
	_target_position = blackboard.get_var(target_position_var, Vector3.ZERO)

	if not agent.navigation_agent.velocity_computed.is_connected(_on_velocity_computed):
		agent.navigation_agent.velocity_computed.connect(_on_velocity_computed, CONNECT_DEFERRED)
		_set_agent_avoidance()

	agent.navigation_agent.target_desired_distance = tolerance


func _tick(delta: float) -> Status:
	if _target_position == Vector3.ZERO:
		return FAILURE

	agent.navigation_agent.target_position = _target_position

	if _is_at_position():
		if patrol: 
			_update_target_position()
		return SUCCESS

	var desired_direction: Vector3 = (agent.navigation_agent.get_next_path_position() - agent.global_position).normalized()
	_rotate_toward_direction(desired_direction, delta)

	agent.navigation_agent.set_velocity(desired_direction * agent.speed)

	return RUNNING


func _is_at_position() -> bool:
	return agent.global_position.distance_to(_target_position) < tolerance


func _rotate_toward_direction(direction: Vector3, delta: float) -> void:
	if face_away: 
		direction = -direction

	var target_angle: float = atan2(-direction.x, -direction.z)
	agent.rotation.y = lerp_angle(agent.rotation.y, target_angle, rotation_speed * delta)


func _update_target_position() -> void:
	var patrol_points: Array[Vector3] = blackboard.get_var(patrol_points_var, [])

	if not patrol_points.is_empty():
		var index: int = (patrol_points.find(_target_position) + 1) % patrol_points.size()
		blackboard.set_var(target_position_var, patrol_points[index])


func _set_agent_avoidance() -> void:
	var shape: Shape3D = agent.collision_shape.shape
	if shape is CapsuleShape3D:
		agent.navigation_agent.radius = shape.radius
		agent.navigation_agent.height = shape.height
	if shape is SphereShape3D:
		agent.navigation_agent.radius = shape.radius
		agent.navigation_agent.height = shape.radius
	if shape is BoxShape3D:
		agent.nav.radius = shape.size.x
		agent.nav.height = shape.size.y


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	agent.velocity = safe_velocity
