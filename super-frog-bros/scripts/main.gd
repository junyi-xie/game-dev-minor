extends Node2D
 
const MAIN_MENU_SCENE = preload("uid://bks1tp7iiyda")
const LEVEL_SCENE = preload("uid://8tyha206enli")

var main_menu: Control
var level: Node2D

func _ready() -> void:
	init()
	SignalManager.game_play.connect(_on_game_play)
	SignalManager.game_exit.connect(_on_game_exit)

func init() -> void:
	main_menu = MAIN_MENU_SCENE.instantiate()
	
	add_child(main_menu)

func _on_game_play() -> void:
	main_menu.queue_free()
	
	level = LEVEL_SCENE.instantiate()
	add_child(level)
	
	get_tree().paused = false 

func _on_game_exit() -> void:
	get_tree().quit()
