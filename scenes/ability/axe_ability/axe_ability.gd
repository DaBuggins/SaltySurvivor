extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent
@onready var other_explode: GPUParticles2D = $Sprite2D/OtherExplode


var base_rotation = Vector2.RIGHT

func _ready() -> void:	
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))	
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 2.5)	
	tween.tween_callback(%AnimationPlayer.pause)	
	tween.tween_callback(emit_explode)
	tween.tween_callback(queue_free).set_delay(1)	
	
	
func tween_method(rotations: float):
	var percent = (rotations / 3)
	var current_radius = percent * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU)	
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	global_position = player.global_position + (current_direction * current_radius)
	
func emit_explode():
	other_explode.emitting = true
