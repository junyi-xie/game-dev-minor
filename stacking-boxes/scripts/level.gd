extends Node3D

@export var camera_controller: Node3D
@export var object_spawner: Node3D
@export var height_detector: Node3D

var camera_offset: float = 2.0
var spawner_offset: float = 1.0
var lerp_speed: float = 2.0

func _ready() -> void:
	camera_controller.global_position.y = object_spawner.global_position.y + camera_offset
	height_detector.global_position.y = object_spawner.global_position.y + spawner_offset
	
func _process(delta: float) -> void:
	object_spawner.object_position = get_object_spawn_position()
	
	var current_camera_y = camera_controller.global_position.y
	var new_camera_y = lerp(current_camera_y, object_spawner.global_position.y + camera_offset, lerp_speed * delta)
	camera_controller.global_position.y = new_camera_y
	
	var current_spawner_y = object_spawner.global_position.y
	var new_spawner_y = lerp(current_spawner_y, height_detector.global_position.y + spawner_offset, lerp_speed * delta)
	object_spawner.global_position.y = new_spawner_y
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop") and object_spawner.object_ready:
		object_spawner.drop_object()
		
func get_object_spawn_position() -> Vector3:
	var screen_pos = get_viewport().get_mouse_position()
	
	var from = camera_controller.camera.project_ray_origin(screen_pos)
	var to = from + camera_controller.camera.project_ray_normal(screen_pos) * 100.0
	
	return from + (to - from).normalized() * 2.5
	
func _on_height_detector_height_updated(new_height: float) -> void:
	camera_offset = new_height + camera_offset
	spawner_offset = new_height + spawner_offset

func _on_area_3d_body_entered(body: Node3D) -> void:
	SignalManager.game_over.emit()
