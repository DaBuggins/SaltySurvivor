extends Button

func _ready() -> void:
	grab_focus()
	pressed.connect(on_pressed)
	
	

func on_pressed():
	CharSounds.back_pressed()

func _process(delta: float) -> void:
	if self.is_hovered() && ControllerManager.is_using_controller == false:
		grab_focus()
