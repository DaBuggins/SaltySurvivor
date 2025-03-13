extends Node2D

@export var breakable_texture = Texture

@onready var crate: CharacterBody2D = $Crate
@onready var crate_2: CharacterBody2D = $Crate2


func _ready() -> void:
	if breakable_texture == null:
		return
	replace_crate_texture(breakable_texture)

func replace_crate_texture(texture):
	crate.replace_texture(texture)
	crate_2.replace_texture(texture)
