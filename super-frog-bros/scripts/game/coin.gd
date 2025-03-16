extends Area2D

@onready var coin_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer

var picked_up: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not picked_up:
		picked_up = true
		
		GameManager.coin_count += 1
		
		coin_sprite.hide()
		pickup_sound.play()
		timer.start()

func _on_timer_timeout() -> void:
	queue_free()
