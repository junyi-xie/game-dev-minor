class_name Player
extends CharacterBody3D

@onready var movement_state_machine: MovementStateMachine = $MovementStateMachine


func _ready() -> void:
	GameManager.player = self


func _input(event: InputEvent) -> void:
	movement_state_machine.input(event)


func _process(delta: float) -> void:
	movement_state_machine.process(delta)


func _physics_process(delta: float) -> void:
	movement_state_machine.physics_process(delta)


func _exit_tree() -> void:
	GameManager.player = null
