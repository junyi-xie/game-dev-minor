extends Control

@onready var v_sync_button: CheckButton = $MarginContainer/VBoxContainer/VSync/VSyncCheckButton

func _ready() -> void:
	pass

func _on_v_sync_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
