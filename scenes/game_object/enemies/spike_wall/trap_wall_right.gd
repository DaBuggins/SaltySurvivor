extends CharacterBody2D

@export_enum("UP", "DOWN","RIGHT","LEFT") var MOVE_DIRECTION

var direction = Vector2.RIGHT

func _ready() -> void:
	if MOVE_DIRECTION == 0:
		direction = Vector2.UP
	elif MOVE_DIRECTION == 1:
		direction = Vector2.DOWN
	elif MOVE_DIRECTION == 2:
		direction = Vector2.RIGHT
	elif MOVE_DIRECTION == 3:
		direction = Vector2.LEFT		
	

func _process(delta: float) -> void:
	move_and_slide()
	velocity = direction * 100
