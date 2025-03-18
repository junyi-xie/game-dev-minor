extends Control

@onready var master_slider: HSlider = $MarginContainer/VBoxContainer/MasterVolume/MasterHSlider
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/MusicVolume/MusicHSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/SoundEffectsVolume/SoundEffectsHSlider

func _ready() -> void:
	var master_volume: float = OptionManager._find("audio", "master_volume")
	var music_volume: float = OptionManager._find("audio", "music_volume")
	var sfx_volume: float = OptionManager._find("audio", "sfx_volume")
	
	_on_master_h_slider_value_changed(master_volume)
	_on_music_h_slider_value_changed(music_volume)
	_on_sound_effects_h_slider_value_changed(sfx_volume)

func _on_master_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.master_bus_index, linear_to_db(value / 100.0))
	
	master_slider.value = value
	OptionManager._update("audio", "master_volume", value)

func _on_music_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.music_bus_index, linear_to_db(value / 100.0))
	
	music_slider.value = value
	OptionManager._update("audio", "music_volume", value)

func _on_sound_effects_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioManager.sfx_bus_index, linear_to_db(value / 100.0))
	
	sfx_slider.value = value
	OptionManager._update("audio", "sfx_volume", value)
