extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var timer = %Timer

var is_moving = false

func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)
	timer.timeout.connect(on_timer_timeout)

func _process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
		
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func set_is_moving(moving: bool):
	is_moving = moving

func on_hit():
	$HitRandomAudioPlayer2DComponent.play_random()

func on_timer_timeout():
	queue_free()
