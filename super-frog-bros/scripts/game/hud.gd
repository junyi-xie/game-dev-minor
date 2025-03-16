extends CanvasLayer

@onready var coin_label: = $CoinCount

func _ready() -> void:
	GameManager.coins_updated.connect(_on_coins_updated)
	coin_label.text = str(GameManager.coin_count)
	
func _on_coins_updated(new_coin_count: int) -> void:
	coin_label.text = str(new_coin_count)
