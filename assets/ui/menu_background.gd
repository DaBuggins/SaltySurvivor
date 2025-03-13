extends Node2D

@onready var office: Sprite2D = $Office
@onready var romford: Sprite2D = $Romford
@onready var farm: Sprite2D = $Farm


func _ready() -> void:
	var backgrounds: Array[Sprite2D] = [office, romford, farm]
	var rand_bg = backgrounds.pick_random()
	rand_bg.visible = true
