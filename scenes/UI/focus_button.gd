extends Button

func _ready() -> void:
	pressed.connect(on_pressed)
	mouse_exited.connect(on_mouse_exit)
	mouse_entered.connect(on_mouse_entered)

func _process(delta: float) -> void:
	if self.is_hovered() && ControllerManager.is_using_controller == false:
		grab_focus()

func on_mouse_exit():
	pass
	
func on_mouse_entered():
	grab_focus()

	
func on_pressed():
	CharSounds.back_pressed()

func button_disabled():
	modulate = Color(1,1,1, 1)
