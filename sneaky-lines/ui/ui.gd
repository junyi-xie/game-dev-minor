extends Control

var paused: bool = false:
	set(value):
		paused = value
		get_tree().paused = value

@onready var title: Label = %Title


func _ready() -> void:
	hide()
	SignalManager.show_ui.connect(_on_show_ui)


func _on_show_ui(text: String) -> void:
	title.text = text
	show()
	paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_retry_button_pressed() -> void:
	paused = false
	get_tree().reload_current_scene()


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
