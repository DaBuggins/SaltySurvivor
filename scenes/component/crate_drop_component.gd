extends Node

@export_range(0, 1) var drop_percent: float = .1	
@export var pickup_pool: Array[PackedScene]
@export var good_pickup_pool: Array[PackedScene]
@export var health_component: Node	

func _ready() -> void:
	(health_component as HealthComponent).died.connect(on_died)

	
func on_died():
	#var adjusted_drop_percent = drop_percent
	#var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
	#if experience_gain_upgrade_count > 0:
		#adjusted_drop_percent += .1		
	if randf() > drop_percent:
		return
	
	if pickup_pool== null:
		return
		
	if not owner is Node2D:
		return
		
	if randf() > 0.95:
		var good_pickup = good_pickup_pool.pick_random()
		drop_item(good_pickup)
	
	var pickup = pickup_pool.pick_random()	
	drop_item(pickup)

	
func drop_item(pickup: PackedScene):
	var spawn_position = (owner as Node2D).global_position
	var pickup_instance = pickup.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(pickup_instance)
	pickup_instance.global_position = spawn_position
