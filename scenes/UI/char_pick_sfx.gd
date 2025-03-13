extends AudioStreamPlayer

@export var pick_sounds: Array[AudioStream]

func _ready() -> void:
	GameEvents.char_selected.connect(on_char_selected)
	self.volume_db = -10
	
func on_char_selected():
	stream = pick_sounds[0]
	play()
