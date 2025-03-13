extends Node2D

@export var replacement_sprite: Texture
@export var replacement_sfx: AudioStream

func _ready() -> void:
	if replacement_sprite == null:
		return
	var breakables = get_children()
	for b in breakables:
		b.replace_texture(replacement_sprite) 
		b.crate_break_component.death_sfx = replacement_sfx
