extends Node2D

const BOID_SCENE: PackedScene = preload("uid://dkyxs54t43p2k")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position: Vector2 = get_global_mouse_position()
		spawn_boid(mouse_position)


func spawn_boid(position: Vector2) -> void:
	var boid: CharacterBody2D = BOID_SCENE.instantiate()
	add_child(boid)

	boid.modulate = Color(randf(), randf(), randf(), 1)
	boid.position = position
