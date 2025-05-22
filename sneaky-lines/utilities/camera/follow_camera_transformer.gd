extends RemoteTransform3D

@export var lerp_weight: float
@export var camera: Node3D


func _process(delta: float) -> void:
	position = lerp(position, camera.position, delta * lerp_weight)
