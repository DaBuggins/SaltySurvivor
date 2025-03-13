extends HealthComponent

func _ready() -> void:
	current_health = max_health

func damage(damage_amount: float):		
	Callable(check_death).call_deferred()


func check_death():	
		if current_health == 0:
			died.emit()
			owner.queue_free()
