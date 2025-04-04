extends AudioStreamPlayer

@export var path_to_music_folder: String
@export var music_formats: Array[String] = ["ogg", "wav"]

var master_bus_index: int
var music_bus_index: int
var sfx_bus_index: int

var music_files: Array

func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	autoplay = true
	
	load_music_files()
	
	if not finished.is_connected(_on_finished):
		finished.connect(_on_finished)
	
	play_random_song()

func _on_finished() -> void:
	play_random_song()

func load_music_files() -> void:
	music_files.clear()
	
	var dir = ResourceLoader.list_directory(path_to_music_folder + "/")
	
	print(dir)
	if not dir:
		return
	
	for file in dir:
		if file.get_extension().to_lower() in music_formats:
			var audio_stream = ResourceLoader.load(path_to_music_folder + "/" +  file)
			if audio_stream:
				music_files.append(audio_stream)

func play_random_song() -> void:
	if music_files.size() > 0:
		stream = music_files[randi() % music_files.size()]
		play()
