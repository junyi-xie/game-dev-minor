extends FreeLookCamera

@export var agent: Agent

@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _process(delta: float) -> void:
	_move_regular_agent()

	super._process(delta)


func _move_regular_agent() -> void:
	if Input.is_action_just_pressed("left_click"):
		_mouse_position = get_viewport().get_mouse_position()
		ray_cast_3d.target_position = project_local_ray_normal(_mouse_position) * 100
		ray_cast_3d.force_raycast_update()

		if ray_cast_3d.is_colliding():
			var position: Vector3 = ray_cast_3d.get_collision_point()
			agent.move_agent_to(position)
