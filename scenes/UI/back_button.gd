extends Button

func _ready() -> void:
	grab_focus()
	pressed.connect(on_pressed)
	GameEvents.disable_back.connect(on_disable_back)


func _process(delta: float) -> void:
	if self.is_hovered() && ControllerManager.is_using_controller == false:
		grab_focus()



func on_pressed():
	CharSounds.back_pressed()

func on_disable_back():
	disabled = true
