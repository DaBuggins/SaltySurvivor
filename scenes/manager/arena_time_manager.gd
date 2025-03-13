extends Node

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL = 5

@export var end_screen_scene: PackedScene
@export var end_boss_kill_screen: PackedScene

@export var end_boss_scene: PackedScene

@onready var entities: Node2D = %Entities
@onready var timer = $Timer
@onready var enemy_spawner: Node2D = %EnemySpawner

var arena_difficulty = 0
var flags_got = 0


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	GameEvents.flag_collected.connect(on_flag_collected)
	GameEvents.end_boss_killed.connect(on_end_boss_killed)

func _process(delta: float) -> void:
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
		
		
func get_time_elapsed():
	return timer.wait_time - timer.time_left
	

func get_current_difficulty():
	return arena_difficulty

func on_timer_timeout():
	if flags_got >= 4:
		var end_boss = end_boss_scene.instantiate() as Node2D
		end_boss.add_to_group("enemy")
		%Bosses.add_child(end_boss)
		end_boss.global_position = entities.global_position
		
		print("BOSS REACHED END")
		#SPAWN BOSS
		return
	end_match(end_screen_scene)

func on_flag_collected(flag_number: int):
	flags_got += 1
	print("FLAG NUMBER:  " + str(flag_number) + "FLAGS GOT:   " + str(flags_got))
	

func end_match(end_screen):
	var end_screen_instance = end_screen.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_victory()
	MetaProgression.save()

func on_end_boss_killed():
	end_match(end_boss_kill_screen)
