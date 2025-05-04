extends FreeLookCamera

@onready var ray_cast_3d: RayCast3D = $RayCast3D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		_handle_left_click()

	super._process(delta)


func _handle_left_click() -> void:
	_mouse_position = get_viewport().get_mouse_position()
	ray_cast_3d.target_position = project_local_ray_normal(_mouse_position) * 100
	ray_cast_3d.force_raycast_update()

	if ray_cast_3d.is_colliding():
		var collider: Node = ray_cast_3d.get_collider()

		if collider is Agent:
			GameManager.selected_agent = collider

		elif GameManager.selected_agent != null:
			var destination: Vector3 = ray_cast_3d.get_collision_point()
			GameManager.selected_agent.move_agent_to(destination)
