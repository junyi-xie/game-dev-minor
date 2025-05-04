extends Node

signal selected_agent_changed(agent)

var selected_agent: Agent = null:
	set(value):
		selected_agent = value
		selected_agent_changed.emit(selected_agent)
