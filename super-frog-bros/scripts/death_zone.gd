extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("dead")
		body.get_node("CollisionShape2D").queue_free()
		timer.start()

func _on_timer_timeout() -> void:
	## TODO, this will emit to our game manager that player has died
	## for now this to reload current scene, but we will have a whole menu
	get_tree().reload_current_scene()
