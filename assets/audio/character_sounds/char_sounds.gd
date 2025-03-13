extends Node

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var victory_jingle: AudioStreamPlayer = %VictoryJingle
@onready var defeat_jingle: AudioStreamPlayer = %DefeatJingle
@onready var confirm_sfx: AudioStreamPlayer = %ConfirmSFX

func _ready() -> void:
	GameEvents.char_selected.connect(on_char_selected)
	GameEvents.win.connect(on_win)
	GameEvents.lose.connect(on_lose)

func on_char_selected(selected_char: Character):
	audio_stream_player.stream = selected_char.pick_sfx
	audio_stream_player.play()

func on_win(winning_char: Character, current_level_id):
	audio_stream_player.stream = winning_char.win_sfx
	audio_stream_player.play()
	victory_jingle.play()

func on_lose(losing_char: Character):
	audio_stream_player.stream = losing_char.lose_sfx
	audio_stream_player.play()
	defeat_jingle.play()

func back_pressed():
	confirm_sfx.play()
