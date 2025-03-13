extends Node

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

func _ready() -> void:
	GameEvents.char_selected.connect(on_char_selected)
	

func on_char_selected(selected_char: Character):
	audio_stream_player.stream = selected_char.pick_sfx
	audio_stream_player.play()
