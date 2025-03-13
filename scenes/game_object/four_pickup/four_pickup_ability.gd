extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var pickup_sfx: AudioStreamPlayer2D = $PickupSFX


var base_damage = 444
var addtional_damage_percent = 1

func _ready() -> void:
	hitbox_component.damage = base_damage * addtional_damage_percent

func play_ability():
	pickup_sfx.play()
	animation_player.play("four_blast")
