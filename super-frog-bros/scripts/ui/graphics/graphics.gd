extends Control

@onready var v_sync_button: CheckButton = $MarginContainer/VBoxContainer/VSync/VSyncCheckButton

func _ready() -> void:
	var v_sync: bool = OptionManager._find("graphics", "v_sync")
	
	_on_v_sync_check_button_toggled(v_sync)

func _on_v_sync_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	v_sync_button.button_pressed = toggled_on
	OptionManager._update("graphics", "v_sync", toggled_on)
