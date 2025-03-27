extends Node3D

@export var path: String

var objects: Array[PackedScene]
var object_ready: bool = false
var current_object: Node3D
var object_position: Vector3

@onready var object_timer: Timer = $Timer

func _ready() -> void:
	
	var files = ResourceLoader.list_directory(path)
	
	if files.is_empty():
		return
		
	for file in files:
		
		if file.ends_with(".tscn"):
			
			var resource_path = path + "/" + file
			var scene: PackedScene = ResourceLoader.load(resource_path)
			
			if scene:
				objects.append(scene)
			else:
				print("Scene couldn't be loaded in: " + resource_path)
				
func _process(delta: float) -> void:
	if not current_object and object_timer.is_stopped():
		object_timer.start()
		
	if current_object and object_ready:
		current_object.global_position = object_position
		
func spawn_object() -> void:
	if objects.is_empty():
		return
		
	current_object = objects.pick_random().instantiate()
	current_object.freeze = true
	object_ready = true
	
	get_tree().current_scene.add_child(current_object)
	
	print("Spawned object: ", current_object.name)
	
func drop_object() -> void:
	if not current_object:
		return
		
	print("Dropping ", current_object.name, " at position: ", current_object.global_position)
	
	current_object.freeze = false
	object_ready = false
	object_timer.start()
	
func _on_timer_timeout() -> void:
	spawn_object()
