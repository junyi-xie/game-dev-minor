extends Node3D

@export_group("Camera")
@export var camera_reference: Camera3D
@export var camera_spring_length: float = 4.8
@export var camera_margin: float = 0.5
@export var camera_smoothness: float = 6.0

@export_group("Entity")
@export var entity_to_follow: Node3D
@export var entity_follow_horizontal_offset: float = 0.0
@export var entity_follow_height: float = 2.8
@export var entity_follow_distance: float = 0.0

@export_group("Sensitity")
@export_range(0.1, 2.0) var horizontal_sensitivity: float = 0.5
@export_range(0.1, 2.0) var vertical_sensitivity: float = 0.5
@export_range(-90.0, 0.0, 0.1) var min_degrees: float = -90.0
@export_range(0.0, 90.0, 0.1) var max_degrees: float = 45.0

@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var follow_camera_transformer: RemoteTransform3D = $FollowCameraTransformer


func _ready() -> void:
	if not camera_reference:
		push_error("No Camera3D set")

	spring_arm_3d.spring_length = camera_spring_length
	spring_arm_3d.margin = camera_margin

	follow_camera_transformer.remote_path = camera_reference.get_path()
	follow_camera_transformer.lerp_weight = camera_smoothness

	call_deferred("reparent", entity_to_follow)
	position = Vector3(entity_follow_horizontal_offset, entity_follow_height, entity_follow_distance)


func _input(event) -> void:
	if event is InputEventMouseMotion:
		entity_to_follow.rotate_y(deg_to_rad(-event.relative.x) * horizontal_sensitivity)
		rotate_x(deg_to_rad(-event.relative.y) * vertical_sensitivity)
		_apply_camera_clamp()


func _process(_delta) -> void:
	_apply_camera_clamp()


func _apply_camera_clamp() -> void:
	rotation.z = 0
	rotation.x = clamp(rotation.x, deg_to_rad(min_degrees), deg_to_rad(max_degrees))
