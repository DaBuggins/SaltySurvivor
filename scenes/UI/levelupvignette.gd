extends CanvasLayer

@export var arena_time_manager: Node

@onready var color_rect: ColorRect = %ColorRect

func _ready() -> void:
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

	
func on_arena_difficulty_increased():
	color_rect.color = Color.ORANGE_RED

	
