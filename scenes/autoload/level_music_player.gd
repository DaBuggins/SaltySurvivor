extends AudioStreamPlayer

@export var level_song: AudioStreamMP3

func _ready() -> void:
	GameEvents.stop_music.connect(on_stop_music)
	GameEvents.start_music.connect(on_start_music)
	GameEvents.run_ended.connect(on_run_ended)
	stream = level_song
	play_if_not_playing()
	finished.connect(on_finished)
	$Timer.timeout.connect(on_timer_timeout)
	
func on_finished():
	$Timer.start()
	

func on_timer_timeout():
	play_if_not_playing()

	
func on_play_pressed():
	pass
	
func on_run_ended():
	stop()

func on_stop_music():
	stop()

func on_start_music():
	play_if_not_playing()

func play_if_not_playing():
	if playing == true:
		pass
	else:
		play()
