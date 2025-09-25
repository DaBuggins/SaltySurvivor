extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = %EndBossVelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)
	health_component.died.connect(on_died)

func _process(delta: float) -> void:
	update_health_display()
	velocity_component.accelerate_to_player()
	velocity_component.move(self)	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)	
	
	

func on_hit():
	$HitRandomAudioPlayer2DComponent.play_random()
	

func on_died():
	GameEvents.emit_end_boss_killed()

func update_health_display():
	health_bar.value = health_component.get_health_percent()
