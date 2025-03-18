extends Node

signal coins_updated(new_coin_count)

var _coin_count: int = 0

var coin_count: int:
	get:
		return _coin_count
	set(value):
		_coin_count = value
		coins_updated.emit(_coin_count) 

func reset_coins() -> void:
	coin_count = 0
