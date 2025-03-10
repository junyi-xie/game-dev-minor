extends CanvasLayer

@onready var state_label = $StateLabel

func update_state_label(state_name: String) -> void:
	state_label.text = "Current State: " + state_name
