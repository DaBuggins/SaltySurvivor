extends Node2D


@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	animation_player.play("shoot")
	await animation_player.animation_finished
	queue_free()
