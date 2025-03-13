extends VBoxContainer

@export var char_sprites: Array[Texture]
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	%CharParticles.texture = char_sprites.pick_random()

func _process(delta: float) -> void:	
	pass

func on_timer_timeout():
	%CharParticles.texture = char_sprites.pick_random()
