extends AudioStreamPlayer

@export var path_to_music_folder: String

var music_files: Array = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	autoplay = true
	
	load_music_files()
	
	finished.connect(_on_finished)
	
	play_random_song()

func _on_finished() -> void:
	play_random_song()

func load_music_files() -> void:
	var dir = DirAccess.open("res://" + path_to_music_folder + "/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".ogg") or file_name.ends_with(".wav"): 
				var file_path = path_to_music_folder + "/" + file_name
				var stream = load(file_path)
				if stream:
					music_files.append(stream)
			file_name = dir.get_next()
	else:
		print("Error: Could not open folder ", path_to_music_folder)

func play_random_song() -> void:
	if music_files.size() > 0:
		var random_index = randi() % music_files.size()
		stream = music_files[random_index]
		play()
	else:
		print("No music files found in folder ", path_to_music_folder)
