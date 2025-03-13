extends Node

@export var axe_ability_scene: PackedScene

var base_damage = 7
var additional_damage = 1
var reload_time = 2
var full_upgrade_bonus = 0

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = reload_time
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = base_damage + additional_damage

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage = current_upgrades["axe_damage"]["quantity"] * 3
		full_upgrade_incr(upgrade)
		
	elif upgrade.id == "axe_rate":		
		var percent_reduction = current_upgrades["axe_rate"]["quantity"] * 0.1
		reload_time = reload_time * (1 - percent_reduction)
		$Timer.wait_time = reload_time
		full_upgrade_incr(upgrade)


func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			additional_damage += 5			
			print(self.name + "BONUS UPGRADE DAMAGE APPLIED")
