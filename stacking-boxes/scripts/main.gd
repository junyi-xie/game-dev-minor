extends Node3D
 
const LEVEL_SCENE = preload("uid://du788rx5jb0ud")
const HUD_SCENE = preload("uid://ciissbqmgrh5s")

var hud: Control
var level: Node3D

func _ready() -> void:
	init()
	SignalManager.game_over.connect(_on_game_over)
	SignalManager.game_retry.connect(_on_game_retry)
	SignalManager.game_quit.connect(_on_game_quit)

func init() -> void:
	level = LEVEL_SCENE.instantiate()
	hud = HUD_SCENE.instantiate()
	
	add_child(hud)
	add_child(level)
	
func _on_game_over() -> void:
	hud.visible = true
	get_tree().paused = true
	
func _on_game_retry() -> void:
	for child in get_tree().current_scene.get_children():
		child.queue_free()
		
	init()
	get_tree().paused = false
	
func _on_game_quit() -> void:
	get_tree().quit()
