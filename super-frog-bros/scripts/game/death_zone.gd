extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		timer.start()

func _on_timer_timeout() -> void:
	get_tree().paused = true
	SceneManager.swap_scenes("GAME_OVER", get_tree().root)
