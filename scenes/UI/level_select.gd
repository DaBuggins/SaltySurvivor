extends CanvasLayer

@export var level_card_scene: PackedScene
@export var levels: Array[Level] = []

@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: Button = %BackButton

func _ready() -> void:	
	back_button.pressed.connect(on_back_pressed)
	get_tree().paused = true
	set_char_cards(levels)
	
func set_char_cards(level_pool: Array[Level]):
	var delay = 0
	for i in level_pool:
		if grid_container.get_child_count() < level_pool.size():			
			var level_instance = level_card_scene.instantiate()
			grid_container.add_child(level_instance)			
			level_instance.play_in(delay)
			level_instance.set_level(i)

			delay += .025
	
	
func on_back_pressed():
	MusicPlayer.stop_char_select_song()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
