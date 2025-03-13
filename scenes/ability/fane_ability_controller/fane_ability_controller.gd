extends Node



@export var fane_ability: PackedScene
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var max_range = 300
var base_damage = 5
var additional_damage = 0
var base_wait_time
var is_fane = false
var fane_instance: Node2D
var travel_time = 3
var full_upgrade_bonus = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	cooldown_timer.timeout.connect(on_cooldown_timeout)
	fane_instance = fane_ability.instantiate() as Node2D
	



func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, travel_time)
	)	
	if enemies.size() == 0:
		return		
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	var enemy_pos = enemies[0].global_position	
	
	if is_fane == true:
		return
	
	is_fane = true
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(fane_instance)
	fane_instance.hitbox_component.damage = base_damage + additional_damage
	
	fane_instance.global_position = player.global_position 
	
	var tween = create_tween()
	tween.tween_property(fane_instance, "position", enemy_pos, travel_time).from_current()
	cooldown_timer.start()


func on_cooldown_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_range, travel_time)
	)	
	if enemies.size() == 0:
		return		
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var enemy_pos = enemies.pick_random().global_position		
	var tween = create_tween()
	tween.tween_property(fane_instance, "position", enemy_pos, travel_time).set_ease(Tween.EASE_OUT)
	audio_stream_player_2d.global_position = fane_instance.global_position
	audio_stream_player_2d.play()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "upgrade_fane_speed":
		travel_time -= .5
		base_wait_time -= .5
		full_upgrade_incr(upgrade)
	elif upgrade.id == "upgrade_fane_damage":
		additional_damage += 3
		full_upgrade_incr(upgrade)
		

func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			additional_damage += 5
			print(self.name + "BONUS UPGRADE DAMAGE APPLIED")
