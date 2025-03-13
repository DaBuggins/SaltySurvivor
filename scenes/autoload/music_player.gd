extends AudioStreamPlayer


@onready var char_select_player: AudioStreamPlayer = %CharSelectPlayer

#
#func _ready() -> void:
	#GameEvents.play_pressed.connect(on_play_pressed)
	#finished.connect(on_finished)
	#$Timer.timeout.connect(on_timer_timeout)
	#
#func on_finished():
	#$Timer.start()
	#
#
#func on_timer_timeout():
	#play_if_not_playing()
#
	#
#func on_play_pressed():
	#stop()
	#
#func on_run_ended():
	#stop()
#
#func play_if_not_playing():
	#if playing == true:
		#pass
	#else:
		#play()

func play_char_select_song():
	stop()
	char_select_player.play()
	
func stop_char_select_song():
	stop()
	char_select_player.stop()
	
