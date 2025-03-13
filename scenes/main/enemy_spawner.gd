extends Node2D

@onready var spawn_timer: Timer = %SpawnTimer
@onready var move_timer: Timer = %MoveTimer

@export var horde_1_scene: PackedScene
@export var horde_2_scene: PackedScene
@export var horde_3_scene: PackedScene
@export var horde_tough1_scene: PackedScene

var spawn_level = 1
var player_pos

func _ready() -> void:
	spawn_timer.timeout.connect(spawn_enemy)
	move_timer.timeout.connect(move_to_player)
	
	
func spawn_enemy():
	spawn_boss()
	spawn_level += 1
	print(spawn_level)
	spawn_timer.start()
	
		
func move_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	player_pos = player.global_position * -3
	var tween = create_tween()

	tween.tween_property(self, "global_position", player_pos, 1.5)
		

func spawn_boss():
	if spawn_level == 1 or spawn_level == 2:
		add_boss(horde_1_scene)
	elif spawn_level == 3 or spawn_level ==  4:
		add_boss(horde_2_scene)
	elif spawn_level == 5 or spawn_level ==  6:
		add_boss(horde_2_scene)
		add_boss(horde_1_scene)	
	elif spawn_level == 7 or spawn_level ==  8:
		add_boss(horde_3_scene)
	elif spawn_level == 9 or spawn_level ==  10:
		add_boss(horde_3_scene)
		add_boss(horde_2_scene)
	elif spawn_level == 11 or spawn_level ==  12:
		add_boss(horde_tough1_scene)
	elif spawn_level == 13 or spawn_level ==  14:
		add_boss(horde_tough1_scene)
		add_boss(horde_3_scene)
		
	
func add_boss(boss):
		var enemy = boss.instantiate() as Node2D
		get_tree().get_first_node_in_group("entities_layer").add_child(enemy)
		enemy.global_position = global_position
		
