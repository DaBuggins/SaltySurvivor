extends CanvasLayer

@export var char_card_scene: PackedScene
@export var chars: Array[Character]= []

@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: Button = %BackButton

func _ready() -> void:	
	back_button.pressed.connect(on_back_pressed)
	MusicPlayer.play_char_select_song()
	get_tree().paused = true
	set_char_cards(chars)
	
func set_char_cards(char_pool: Array[Character]):
	var delay = 0
	var card_amount = char_pool.size()		
	for c in char_pool:
		if grid_container.get_child_count() < char_pool.size():				
			var card_instance = char_card_scene.instantiate()
			grid_container.add_child(card_instance)			
			card_instance.play_in(delay)
			card_instance.set_char(c)
			
			if card_amount == char_pool.size():
				card_instance.focus_button.grab_focus()
			card_amount -= 1
			delay += .025
			

			
			
func on_back_pressed():
	MusicPlayer.stop_char_select_song()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
