extends Button

func _ready() -> void:
	pressed.connect(on_pressed)


func _process(delta: float) -> void:
	if disabled:
		mouse_filter = MOUSE_FILTER_IGNORE



	
func on_pressed():

	CharSounds.back_pressed()
