extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_back_pressed() -> void:
	queue_free()

func _on_save_pressed() -> void:
	OptionManager._save()
	queue_free()
