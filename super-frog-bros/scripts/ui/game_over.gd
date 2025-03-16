extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_restart_pressed() -> void:
	SceneManager.swap_scenes("LEVEL", get_tree().root, true)
	get_tree().paused = false

func _on_exit_pressed() -> void:
	SceneManager.swap_scenes("MAIN_MENU", get_tree().root, true)
	get_tree().paused = false
