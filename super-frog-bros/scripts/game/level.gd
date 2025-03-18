extends Node2D

func _ready() -> void:
	GameManager.reset_coins()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SceneManager.swap_scenes("PAUSE_MENU", get_tree().root)
		get_tree().paused = true
