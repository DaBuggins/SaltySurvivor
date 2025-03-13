extends CharacterBody2D

@onready var velocity_component: Node = $VelocityComponent
@onready var timer: Timer = %Timer
@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals: Node2D = %Visuals



func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)
	timer.timeout.connect(on_timer_timeout)

func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	


func on_hit():
	$HitRandomAudioPlayer2DComponent.play_random()
	
func on_timer_timeout():
	queue_free()
