extends CanvasLayer

@onready var play_button: Button = %PlayButton
@onready var upgrades_button: Button = %UpgradesButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton


var options_scene = preload("res://scenes/UI/options_menu.tscn")
var upgrade_scene = preload("res://scenes/UI/meta_menu.tscn")

var using_mouse = true


func _ready() -> void:	
	

	MusicPlayer.play()	
	
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	upgrades_button.pressed.connect(on_upgrades_pressed)	

	play_button.grab_focus()	
		


func _process(delta: float) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		play_button.grab_focus()
	
func on_play_pressed():
	GameEvents.emit_play_pressed()
	get_tree().change_scene_to_file("res://scenes/UI/char_select.tscn")
	
func on_options_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	
func on_upgrades_pressed():
	var upgrade_instance = upgrade_scene.instantiate()
	add_child(upgrade_instance)
	upgrade_instance.back_pressed.connect(on_upgrades_closed.bind(upgrade_instance))
	

	
func on_quit_pressed():
	get_tree().quit()

func on_options_closed(options_instance: Node):
	%PlayButton.grab_focus()
	options_instance.queue_free()

func on_upgrades_closed(upgrades_instance: Node):
	%PlayButton.grab_focus()
	upgrades_instance.queue_free()
