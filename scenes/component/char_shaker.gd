extends VBoxContainer

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	%CharParticles.texture = GameEvents.current_char.sprite
