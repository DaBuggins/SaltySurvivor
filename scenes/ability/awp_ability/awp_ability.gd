extends Node2D


@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var shoot_sfx: AudioStreamPlayer2D = $ShootSFX


func _ready() -> void:
	animation_player.play("shoot")
	await animation_player.animation_finished
	queue_free()

func reduce_volume():
	var current_volume = shoot_sfx.volume_db
	shoot_sfx.volume_db  = current_volume - 5
