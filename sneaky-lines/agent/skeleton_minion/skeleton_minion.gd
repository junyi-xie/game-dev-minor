extends Agent

@export_group("Patrol Settings")
@export var waypoints: Array[Vector3]


func _ready() -> void:
	bt_player.blackboard.set_var(&"patrol_points", waypoints)
	bt_player.blackboard.set_var(&"target_position", waypoints[0])
