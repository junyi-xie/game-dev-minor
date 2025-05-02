class_name Agent
extends CharacterBody3D

@export var speed: int = 10
@export var acceleration: int = 15

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


func _physics_process(_delta: float) -> void:
	move_and_slide()
