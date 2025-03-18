extends Control

@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/MasterVolume/MasterHSlider
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/MusicVolume/MusicHSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/SoundEffectsVolume/SoundEffectsHSlider

func _ready() -> void:	
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioManager.master_bus_index)) * 100
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioManager.music_bus_index)) * 100
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioManager.sfx_bus_index)) * 100

func _on_master_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.master_bus_index, linear_to_db(value / 100.0))

func _on_music_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.music_bus_index, linear_to_db(value / 100.0))

func _on_sound_effects_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.sfx_bus_index, linear_to_db(value / 100.0))
