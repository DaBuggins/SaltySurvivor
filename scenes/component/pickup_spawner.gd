extends Node2D

@onready var spawn_timer: Timer = %SpawnTimer
@onready var move_timer: Timer = %MoveTimer

@export var boss_chicken_scene: PackedScene
@export var boss_potato_scene: PackedScene
@export var boss_truck_scene: PackedScene
@export var boss_ghost_scene: PackedScene

var is_flipped = false
var spawn_level = 1

func _ready() -> void:
	spawn_timer.timeout.connect(spawn_enemy)
	move_timer.timeout.connect(move_to_player)
	
func spawn_enemy():	
	spawn_boss()
	spawn_level += 1
	spawn_timer.start()
		
func move_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if is_flipped:
		is_flipped = false
		global_position.x = player.global_position.x + 300
		global_position.y = player.global_position.y + 300
	else:
		is_flipped = true
		global_position.x = player.global_position.x - 300
		global_position.y = player.global_position.y - 300

func add_boss(boss):
		var enemy = boss.instantiate() as Node2D
		get_tree().get_first_node_in_group("entities_layer").add_child(enemy)
		enemy.global_position = global_position
		

func spawn_boss():
	if spawn_level == 1:
		add_boss(boss_chicken_scene)
	elif spawn_level == 2:
		add_boss(boss_potato_scene)
	elif spawn_level == 3:
		add_boss(boss_ghost_scene)
	elif spawn_level == 4:
		add_boss(boss_truck_scene)
