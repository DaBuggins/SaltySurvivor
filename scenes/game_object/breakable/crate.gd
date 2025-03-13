extends CharacterBody2D

@export var replacement_sprite: Texture2D
@export var replacement_sfx: AudioStream

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var crate_break_component: Node2D = %CrateBreakComponent

func _ready() -> void:
	if replacement_sprite == null:
		return
	replace_texture(replacement_sprite)
	if replacement_sfx == null:
		return
	crate_break_component.death_sfx = replacement_sfx

func replace_texture(texture):
	sprite_2d.texture = texture
	crate_break_component.sprite.texture = texture
