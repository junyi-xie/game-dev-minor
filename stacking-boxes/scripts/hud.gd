extends Control

func _ready():
	self.hide()

func _on_retry_pressed() -> void:
	SignalManager.game_retry.emit()

func _on_quit_game_pressed() -> void:
	SignalManager.game_quit.emit()
