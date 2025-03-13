extends Node2D

@onready var spawn_timer: Timer = %SpawnTimer

@export var trap_wall_scene: PackedScene

@export var spawn_time: int = 20

func _ready() -> void:
	spawn_timer.timeout.connect(spawn_trap)	
	spawn_timer.start(spawn_time)
	
func spawn_trap():
	var trap = trap_wall_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("entities_layer").add_child(trap)
	trap.global_position = global_position

		
