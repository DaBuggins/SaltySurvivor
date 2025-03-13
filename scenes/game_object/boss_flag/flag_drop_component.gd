extends Sprite2D

@export var flag_scene: PackedScene
@export var health_component: Node	

func _ready() -> void:
	(health_component as HealthComponent).died.connect(on_died)		
	
func on_died():		
	if flag_scene == null:
		return
		
		
	var spawn_position = (owner as Node2D).global_position
	var pickup_instance = flag_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(pickup_instance)
	pickup_instance.global_position = spawn_position
	
