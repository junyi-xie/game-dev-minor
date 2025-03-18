extends Control

var is_remapping = false
var action_to_remap = null
var remapping_button = null

@onready var action_list: VBoxContainer = $MarginContainer/VBoxContainer

func _ready() -> void:
	for action in OptionManager._find("key_binding"):
		var event_str = OptionManager._find("key_binding", action)
		var input_event = _string_to_input_event(event_str)
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, input_event)
	
	_create_action_list()
	
func _input(event) -> void:
	if is_remapping:
		if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			
			_update_action_list(remapping_button, event)
			
			OptionManager._update("key_binding", action_to_remap, _input_event_to_string(event))
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _create_action_list() -> void:
	for item in action_list.get_children():
		item.queue_free()
		
	for action in OptionManager._find("key_binding"):
		var button = load("uid://dby67pg1f5pkk").instantiate()
		var action_label = button.find_child("ActionLabel")
		var input_label = button.find_child("InputLabel")
		
		action_label.text = action.replace("_", " ").capitalize()
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action) -> void:
	if not is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("InputLabel").text = "Press key to bind..."

func _update_action_list(button, event) -> void:
	button.find_child("InputLabel").text = event.as_text().trim_suffix(" (Physical)")

func _string_to_input_event(string: String) -> InputEvent:
	var input_event: InputEvent
	
	if string.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(string.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(string)
	
	return input_event

func _input_event_to_string(event: InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		return "mouse_" + str(event.button_index)
	return ""
