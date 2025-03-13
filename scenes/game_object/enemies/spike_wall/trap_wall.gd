extends CharacterBody2D


@onready var timer: Timer = $Timer

@export var spawn_time: int


@export_enum("UP", "DOWN","RIGHT","LEFT") var MOVE_DIRECTION

var direction = Vector2.DOWN

func _ready() -> void:
	timer.start(spawn_time)

	if MOVE_DIRECTION == 0:
		direction = Vector2.UP
	elif MOVE_DIRECTION == 1:
		direction = Vector2.DOWN
	elif MOVE_DIRECTION == 2:
		direction = Vector2.RIGHT
	elif MOVE_DIRECTION == 3:
		direction = Vector2.LEFT		
	

func _process(delta: float) -> void:
	if timer.time_left == 0:
		move_and_slide()
		velocity = direction * 100
