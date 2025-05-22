extends Node3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_finish_area_body_entered(body: Node3D) -> void:
	if body is Player:
		print("win")
