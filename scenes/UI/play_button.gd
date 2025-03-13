extends Button

func _ready() -> void:
	pressed.connect(on_pressed)
	mouse_exited.connect(on_mouse_exit)
	mouse_entered.connect(on_mouse_entered)



func on_mouse_exit():
	pass
	
func on_mouse_entered():
	if disabled:
		return
	grab_focus()

	
func on_pressed():

	CharSounds.back_pressed()
