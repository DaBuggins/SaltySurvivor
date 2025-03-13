extends Sprite2D

func _ready() -> void:
	if owner == null:
		return
		
	texture = get_parent().texture
