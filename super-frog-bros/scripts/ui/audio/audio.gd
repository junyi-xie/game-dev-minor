extends Control

@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/MusicVolume/MusicHSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/SFXVolume/SFXHSlider

func _ready() -> void:
	pass

func _on_music_h_slider_value_changed(value: float) -> void:
	print(value)

func _on_sfx_h_slider_value_changed(value: float) -> void:
	print(value)
