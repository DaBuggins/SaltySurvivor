@tool

extends Node2D

@export var enemy_scene: PackedScene
var enemy_positions: Array
var horde_enemy_scene


func _ready() -> void:
	horde_enemy_scene = enemy_scene
	enemy_positions = [Vector2(0, 0), Vector2(26, 6), Vector2(-23, 10), Vector2(2, 23), Vector2(-20, -15), Vector2(-1, -28), Vector2(24, -19), Vector2(51, -4), Vector2(41, 33), Vector2(-28, 37)]
	spawn_enemies()
	
	
func replace_enemy(replacement_enemy):
	horde_enemy_scene = replacement_enemy
	spawn_enemies()

func spawn_enemies():
	var enemies = get_children()
	if enemies != null:	
		for e in enemies:
			e.queue_free()

	#for e in enemies:
		#enemy_positions.append(e.global_position)		
	for e in enemy_positions:
		var spawn_pos = e
		var enemy = horde_enemy_scene.instantiate() as Node2D
		self.add_child(enemy)
		enemy.global_position = spawn_pos
	print(enemy_positions)
	
	
