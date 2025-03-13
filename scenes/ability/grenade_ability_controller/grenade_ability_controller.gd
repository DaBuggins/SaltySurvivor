extends Node

@export var grenade_ability_scene: PackedScene

var base_damage = 88888
var additional_damage = 0
var grenade_rotation = 0
var grenade_count = 0
var full_upgrade_bonus = 0

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	for i in grenade_count + 1:
		var grenade_instance = grenade_ability_scene.instantiate() as Node2D
		foreground.add_child(grenade_instance)
		grenade_instance.rotate(deg_to_rad(grenade_rotation))
		grenade_rotation += 90
		grenade_instance.global_position = player.global_position
		grenade_instance.hitbox_component.damage = base_damage + additional_damage
	


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "grenade_count":
		grenade_count = current_upgrades["grenade_count"]["quantity"]
		full_upgrade_incr(upgrade)
	elif upgrade.id == "grenade_damage":
		additional_damage = current_upgrades["grenade_damage"]["quantity"] * 3
		full_upgrade_incr(upgrade)

func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			additional_damage += 4
			GameEvents.full_upgrade.emit(upgrade)
			print(self.name + "  BONUS UPGRADE DAMAGE APPLIED")
