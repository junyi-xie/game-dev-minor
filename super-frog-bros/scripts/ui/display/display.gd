extends Control

@onready var resolution_button: OptionButton = $MarginContainer/VBoxContainer/Resolution/ResolutionButton
@onready var full_screen_button: CheckButton = $MarginContainer/VBoxContainer/FullScreen/FullScreenCheckButton
@onready var borderless_button: CheckButton = $MarginContainer/VBoxContainer/Borderless/BorderlessCheckButton

const RESOLUTIONS: Dictionary = {
	"640x360": Vector2i(640, 360),
	"800x450": Vector2i(800, 450),
	"854x480": Vector2i(854, 480),
	"1024x576": Vector2i(1024, 576),
	"1152x648": Vector2i(1152, 648),
	"1280x720": Vector2i(1280, 720),
	"1366x768": Vector2i(1366, 768),
	"1600x900": Vector2i(1600, 900),
	"1920x1080": Vector2i(1920, 1080),
	"2560x1440": Vector2i(2560, 1440)
}

func _ready() -> void:
	for resolution in RESOLUTIONS:
		resolution_button.add_item(resolution)

func _on_resolution_button_item_selected(index: int) -> void:
	var new_size = RESOLUTIONS.values()[index]
	DisplayServer.window_set_size(new_size)
	
	var screen_index = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen_index)

	var new_position = (screen_size - new_size) / 2
	DisplayServer.window_set_position(new_position)

	resolution_button.selected = index

func _on_full_screen_check_button_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_borderless_check_button_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)
