extends Node

@export var rainbow_six_ability_scene: PackedScene


var base_damage = 6
var additional_damage = 0
var spawn_time = 6
var full_upgrade_bonus = 0

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)	
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout():
	spawn_six()
	$Timer.wait_time = spawn_time
	
func spawn_six():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var rainbow_six_instance = rainbow_six_ability_scene.instantiate() as Node2D
	foreground.add_child(rainbow_six_instance)
	rainbow_six_instance.global_position = player.global_position
	rainbow_six_instance.hitbox_component.damage = base_damage + additional_damage
	
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "rainbow_six_damage":
		additional_damage = (current_upgrades["rainbow_six_damage"]["quantity"] * 3)
		full_upgrade_incr(upgrade)
	elif upgrade.id == "rainbow_six_rate":
		spawn_time = 6 - (current_upgrades["rainbow_six_rate"]["quantity"])
		full_upgrade_incr(upgrade)

func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			additional_damage += 4
			print(self.name + "   BONUS UPGRADE DAMAGE APPLIED")
