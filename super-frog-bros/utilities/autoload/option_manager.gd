extends Node

const SETTINGS_FILE_PATH = "user://settings.ini"

var options: Dictionary = {}
var default_options: Resource = preload("uid://cvb0wdduxpmj1")

var config = ConfigFile.new()

func _ready() -> void:
	_load()
	
	if options.is_empty():
		options = default_options.DEFAULT.duplicate(true)
		
	_apply()

func _save() -> void:
	for section in options:
		for key in options[section]:
			config.set_value(section, key, options[section][key])
	
	config.save(SETTINGS_FILE_PATH)

func _update(section: String, key: String, value) -> void:
	if not section in options:
		return
	
	options[section][key] = value

func _load() -> void:
	options.clear()
	
	var result = config.load(SETTINGS_FILE_PATH)
	if result != OK:
		return
	
	for section in config.get_sections():
		options[section] = {}
		
		for key in config.get_section_keys(section):
			options[section][key] = config.get_value(section, key)

# idk, not the cleanest way to apply the settings
# can probably use signals, but it was too late at this point 😭😭
func _apply() -> void:
	for section in options:
		for key in options[section]:
			match key:
				"resolution":
					var resolution_parts = options[section][key].split("x")
					var width = int(resolution_parts[0])
					var height = int(resolution_parts[1])
					var new_size = Vector2i(width, height)
					DisplayServer.window_set_size(new_size)
					
					var screen_index = DisplayServer.window_get_current_screen()
					var screen_size = DisplayServer.screen_get_size(screen_index)
					var new_position = (screen_size - new_size) / 2
					DisplayServer.window_set_position(new_position)
				"full_screen":
					if options[section][key]:
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
					else:
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				"borderless":
					DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, options[section][key])
				"v_sync":
					if options[section][key]:
						DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
					else:
						DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
				"master_volume":
					AudioServer.set_bus_volume_db(AudioManager.master_bus_index, linear_to_db(options[section][key] / 100.0))
				"music_volume":
					AudioServer.set_bus_volume_db(AudioManager.music_bus_index, linear_to_db(options[section][key] / 100.0))
				"sfx_volume":
					AudioServer.set_bus_volume_db(AudioManager.sfx_bus_index, linear_to_db(options[section][key] / 100.0))
				"move_left", "move_right", "jump", "pause":
					var event_str = options[section][key]
					var input_event: InputEvent
	
					if event_str.contains("mouse_"):
						input_event = InputEventMouseButton.new()
						input_event.button_index = int(event_str.split("_")[1])
					else:
						input_event = InputEventKey.new()
						input_event.keycode = OS.find_keycode_from_string(event_str)
					
					InputMap.action_erase_events(key)
					InputMap.action_add_event(key, input_event)

func _find(section: String, key: String = "") -> Variant:
	if section in options:
		if key.is_empty():
			return options[section]
		elif key in options[section]:
			return options[section][key]
	
	return null
