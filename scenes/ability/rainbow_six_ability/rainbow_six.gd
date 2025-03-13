extends Node2D

const MAX_RADIUS = 75

@onready var hitbox_component = $HitboxComponent
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var base_rotation = Vector2.LEFT

func _ready() -> void:
	audio_stream_player_2d.play()
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))	
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 3, 12).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
	
	
	
func tween_method(rotations: float):
	var percent = (rotations / 2)
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)
	
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = player.global_position + (current_direction * current_radius)
