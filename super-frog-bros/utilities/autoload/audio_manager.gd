extends AudioStreamPlayer

@export var path_to_music_folder: String
@export var music_formats: Array[String] = ["ogg", "wav"]

var master_bus_index: int
var music_bus_index: int
var sfx_bus_index: int

var music_files: Array = []

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
	
	var dir = DirAccess.open("res://" + path_to_music_folder + "/")
	
	if not dir:
		return
	
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.get_extension().to_lower() in music_formats:
			var file_path = path_to_music_folder + "/" + file_name
			var audio_stream = load(file_path)
			if audio_stream:
				music_files.append(audio_stream)
		file_name = dir.get_next()
		
	dir.list_dir_end()

func play_random_song() -> void:
	if music_files.size() > 0:
		stream = music_files[randi() % music_files.size()]
		play()
