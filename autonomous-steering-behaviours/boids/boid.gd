extends CharacterBody2D

@export_group("Pathfinding")
@export var tolerance: float = 2.0

@export_group("Movement")
@export var speed: float = 350.0
@export var mass: float = 1.2
@export var max_steering: float = 200.0

@export_group("Flocking Behaviour")
@export var separation_weight: float = 1.3
@export var alignment_weight: float = 2.2
@export var cohesion_weight: float = 0.8

@export_group("Obstacle Avoidance")
@export var avoidance: bool = true

var target_position: Vector2 = Vector2.ZERO
var neighbors: Array[CharacterBody2D] = []

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	add_to_group("Boid")

	if not navigation_agent.velocity_computed.is_connected(_on_velocity_computed):
		navigation_agent.velocity_computed.connect(_on_velocity_computed, CONNECT_DEFERRED)

	if avoidance: _set_agent_avoidance()

	navigation_agent.avoidance_enabled = avoidance
	navigation_agent.target_desired_distance = tolerance


func _physics_process(_delta: float) -> void:
	if target_position:
		navigation_agent.target_position = target_position

	rotation = lerp_angle(rotation, velocity.angle(), 0.5)

	move_and_slide()


func _process(_delta: float) -> void:
	target_position = get_global_mouse_position()


func compute_flocking() -> Vector2:
	if neighbors.is_empty():
		return Vector2.ZERO

	var separation: Vector2 = compute_separation()
	var alignment: Vector2 = compute_alignment()
	var cohesion: Vector2 = compute_cohesion()

	return (separation * separation_weight) + (alignment * alignment_weight) + (cohesion * cohesion_weight)


## Method that calculates the separation force to avoid crowding neighbors.
func compute_separation() -> Vector2:
	var separation: Vector2 = Vector2.ZERO
	var count: int = 0

	for neighbor in neighbors:
		if neighbor == self:
			continue

		var offset: Vector2 = global_position - neighbor.global_position
		separation += offset.normalized() / offset.length()
		count += 1

	if count == 0:
		return separation

	return ((separation / count).normalized() * speed - velocity).limit_length(max_steering)


## Method that calculates the alignment steering force to match the average velocity of its neighbors.
func compute_alignment() -> Vector2:
	var alignment: Vector2 = Vector2.ZERO
	var count: int = 0

	for neighbor in neighbors:
		if neighbor == self:
			continue

		alignment += neighbor.velocity
		count += 1

	if count == 0:
		return alignment

	return ((alignment / count).normalized() * speed - velocity).limit_length(max_steering)


## Method that calculates the cohesion steering force to move the boid toward the center of its neighbors.
func compute_cohesion() -> Vector2:
	var cohesion: Vector2 = Vector2.ZERO
	var count: int = 0

	for neighbor in neighbors:
		if neighbor == self:
			continue

		cohesion += neighbor.global_position
		count += 1

	if count == 0:
		return cohesion

	return (((cohesion / count) - global_position).normalized() * speed - velocity).limit_length(max_steering)


## This method returns the steering force that moves the agent toward from the mouse position.
func get_seek_force() -> Vector2:
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var desired_velocity: Vector2 = global_position.direction_to(next_path_position) * speed
	var steering_force: Vector2 = (desired_velocity - velocity) / mass
	return steering_force.limit_length(max_steering)


## This method returns the steering force that moves the agent away from the mouse position.
func get_flee_force() -> Vector2:
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var desired_velocity: Vector2 = -(global_position.direction_to(next_path_position) * speed)
	var steering_force: Vector2 = (desired_velocity - velocity) / mass
	return steering_force.limit_length(max_steering)


## This method sets the agent avoidance radius based on the collision shape of the agent. 
func _set_agent_avoidance() -> void:
	var shape: Shape2D = collision_shape.shape
	if shape is CapsuleShape2D or shape is CircleShape2D:
		navigation_agent.radius = shape.radius
	if shape is RectangleShape2D:
		navigation_agent.radius = max(shape.size.x, shape.size.y)


## Observer method that detects if any body has entered our detection area.
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Boid") and body != self:
		if not neighbors.has(body):
			neighbors.append(body)


## Observer method that detects if any body has exited our detection area.
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Boid"):
		neighbors.erase(body)


## This methods updates the agent's velocity with the safe velocity.
func _on_velocity_computed(safe_velocity: Vector2) -> void:
	var flock_force: Vector2 = compute_flocking()
	var steering_force: Vector2

	match GameManager.steering_mode:
		GameManager.SteeringMode.SEEK:
			steering_force = get_seek_force()
		GameManager.SteeringMode.FLEE:
			steering_force = get_flee_force()
		_:
			steering_force = Vector2.ZERO

	velocity = safe_velocity + (flock_force + steering_force) * get_process_delta_time()
	velocity = velocity.limit_length(speed)
	navigation_agent.set_velocity(velocity)
