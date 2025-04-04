extends RayCast3D

signal height_updated(new_height: float)

var highest_point: float = 0.0


func _physics_process(_delta: float) -> void:
	if is_colliding():

		var collision_point = get_collision_point()
		if collision_point.y > highest_point + 0.01:
			highest_point = collision_point.y
			emit_signal("height_updated", highest_point)
