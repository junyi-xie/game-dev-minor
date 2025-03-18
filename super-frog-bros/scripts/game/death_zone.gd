extends Area2D

@onready var sound = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_node("AnimatedSprite2D").play("hit")
		body.get_node("CollisionShape2D").queue_free()
		
		sound.play()
		await sound.finished
		
		get_tree().paused = true
		SceneManager.swap_scenes("GAME_OVER", get_tree().root)
