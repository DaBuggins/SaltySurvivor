extends Node

@export var end_screen_scene: PackedScene
@export var level_id: String

var pause_menu_scene = preload("res://scenes/UI/pause_menu.tscn")


func _ready() -> void:
	%Player.health_component.died.connect(on_player_died)
	GameEvents.current_level_id = level_id
	print(str(GameEvents.current_level_id))
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
	
func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
