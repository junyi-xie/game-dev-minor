extends CanvasLayer

const REGULAR_AGENT_SCENE: PackedScene = preload("uid://d0gan53aegwcm")
const PATROL_AGENT_SCENE: PackedScene = preload("uid://buku4pgku1xip")


func _on_spawn_regular_agent() -> void:
	var agent: Agent = REGULAR_AGENT_SCENE.instantiate()
	add_child(agent)


func _on_spawn_patrol_agent() -> void:
	var agent: Agent = PATROL_AGENT_SCENE.instantiate()
	add_child(agent)
