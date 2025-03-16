extends Control

var center: Vector2
var tween: Tween

@onready var node = $Control

func _ready() -> void:
	center = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)

func _process(delta: float) -> void:
	var offset = center - get_global_mouse_position() * 0.1
	
	if tween and tween.is_running():
		return  
		
	tween = node.create_tween()
	tween.tween_property(node, "position", offset, 1.1 * delta)

func _on_item_rect_changed() -> void:
	center = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	
	if node != null:
		node.global_position = center

func _on_play_pressed() -> void:
	SceneManager.swap_scenes("LEVEL", get_tree().root, true)

func _on_options_pressed() -> void:
	## go to options menu
	pass

func _on_quit_game_pressed() -> void:
	get_tree().quit()
