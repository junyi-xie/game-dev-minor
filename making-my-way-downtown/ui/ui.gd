extends CanvasLayer

const REGULAR_AGENT_SCENE: PackedScene = preload("uid://d0gan53aegwcm")
const PATROL_AGENT_SCENE: PackedScene = preload("uid://buku4pgku1xip")

@onready var label: Label = %Label


func _ready() -> void:
	GameManager.selected_agent_changed.connect(_on_selected_agent_changed)


func _on_selected_agent_changed(agent: Agent) -> void:
	if agent and agent.label:
		label.text = "Current selected agent: %s" % agent.label.text


func _spawn_agent(agent_scene: PackedScene, label_prefix: String) -> void:
	var agent: Agent = agent_scene.instantiate()

	var same_type_count: int = 0

	for child in get_parent().get_children():
		if child is Agent and child.label.text.begins_with(label_prefix):
			same_type_count += 1

	get_parent().add_child(agent)

	agent.label.text = "%s %d" % [label_prefix, same_type_count + 1]


func _on_spawn_regular_agent() -> void:
	_spawn_agent(REGULAR_AGENT_SCENE, "Regular")


func _on_spawn_patrol_agent() -> void:
	_spawn_agent(PATROL_AGENT_SCENE, "Patrol")
