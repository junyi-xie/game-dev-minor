extends Agent

@export_group("Patrol Settings")
@export var waypoints: Array[Vector3]

@onready var vision_area: Area3D = $VisionArea


func _ready() -> void:
	bt_player.blackboard.set_var(&"patrol_points", waypoints)
	bt_player.blackboard.set_var(&"target_position", waypoints[0])


func _process(delta: float) -> void:
	for body in vision_area.get_overlapping_bodies():
		if _in_field_of_vision(body):
			print("i caught you")
		else:
			print("obstacle in the way")


func _in_field_of_vision(target: Node3D) -> bool:
	var from: Vector3 = global_transform.origin
	var to: Vector3 = target.global_transform.origin

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var result: Dictionary = space_state.intersect_ray(query)

	return result.has("collider") and result.collider == target
