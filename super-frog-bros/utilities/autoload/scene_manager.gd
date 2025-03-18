extends Node

var scenes: Dictionary = {
	"MAIN_MENU": preload("uid://bks1tp7iiyda"),
	"LEVEL": preload("uid://8tyha206enli"),
	"GAME_OVER": preload("uid://c66xcqwm6cpbj"),
	"PAUSE_MENU": preload("uid://drsjw1xw8i3co"),
	"OPTION_MENU": preload("uid://y8bff5qgdumd")
}

func swap_scenes(scene_to_load, load_into: Node, clear_existing_scenes: bool = false) -> void:
	if not load_into:
		return
		
	if not scenes.has(scene_to_load):
		return
		
	if clear_existing_scenes:
		for child in load_into.get_children():
			if not child.name in ["GameManager", "SceneManager", "AudioManager"]: ## i was braindead, not efficient this way
				child.queue_free()
		
	var new_scene = scenes[scene_to_load].instantiate()
	load_into.add_child(new_scene)
