class_name Player
extends CharacterBody2D

@onready var animations = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var ui_scene = get_parent().get_node("UI")

var can_double_jump: bool = true

func _ready() -> void:
	state_machine.init(self)
	
	state_machine.state_changed.connect(ui_scene.update_state_label)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
