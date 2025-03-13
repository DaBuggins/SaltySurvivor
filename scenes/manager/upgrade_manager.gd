extends Node


@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var current_weapons = 0
var weapon_pool = []
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_knife = preload("res://resources/upgrades/knife.tres")
var upgrade_knife_rate = preload("res://resources/upgrades/knife_rate.tres")
var upgrade_knife_damage = preload("res://resources/upgrades/knife_damage.tres")
var upgrade_glock = preload("res://resources/upgrades/glock.tres")
var upgrade_glock_rate = preload("res://resources/upgrades/glock_rate.tres")
var upgrade_glock_damage = preload("res://resources/upgrades/glock_damage.tres")
var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_axe_rate = preload("res://resources/upgrades/axe_rate.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_pickup_radius = preload("res://resources/upgrades/pickup_radius.tres")
var upgrade_harddrive = preload("res://resources/upgrades/harddrive.tres")
var upgrade_harddrive_count = preload("res://resources/upgrades/harddrive_count.tres")
var upgrade_harddrive_damage = preload("res://resources/upgrades/harddrive_damage.tres")
var upgrade_galil = preload("res://resources/upgrades/galil.tres")
var upgrade_galil_damage = preload("res://resources/upgrades/galil_damage.tres")
var upgrade_galil_rate = preload("res://resources/upgrades/galil_rate.tres")
var upgrade_grenade = preload("res://resources/upgrades/grenade.tres")
var upgrade_grenade_count = preload("res://resources/upgrades/grenade_count.tres")
var upgrade_grenade_damage = preload("res://resources/upgrades/grenade_damage.tres")
var upgrade_fane = preload("res://resources/upgrades/fane.tres")
var upgrade_fane_speed = preload("res://resources/upgrades/fane_speed.tres")
var upgrade_fane_damage = preload("res://resources/upgrades/fane_damage.tres")
var upgrade_chicken = preload("res://resources/upgrades/chicken.tres")
var upgrade_chicken_count = preload("res://resources/upgrades/chicken_count.tres")
var upgrade_chicken_damage = preload("res://resources/upgrades/chicken_damage.tres")
var upgrade_wall = preload("res://resources/upgrades/wall.tres")
var upgrade_wall_rate = preload("res://resources/upgrades/wall_rate.tres")
var upgrade_wall_damage = preload("res://resources/upgrades/wall_damage.tres")
var upgrade_awp = preload("res://resources/upgrades/awp.tres")
var upgrade_awp_rate = preload("res://resources/upgrades/awp_rate.tres")
var upgrade_awp_damage = preload("res://resources/upgrades/awp_damage.tres")
var upgrade_rainbow_six = preload("res://resources/upgrades/rainbow_six.tres")
var upgrade_rainbow_six_rate = preload("res://resources/upgrades/rainbow_six_rate.tres")
var upgrade_rainbow_six_damage = preload("res://resources/upgrades/rainbow_six_damage.tres")
var upgrade_health_up = preload("res://resources/upgrades/health_up.tres")

func _ready() -> void:	
	upgrade_pool.add_item(upgrade_player_speed, 155555)
	upgrade_pool.add_item(upgrade_pickup_radius, 15)
	upgrade_pool.add_item(upgrade_health_up, 1)
	upgrade_pool.add_item(upgrade_knife, 10)	
	upgrade_pool.add_item(upgrade_glock, 10)
	upgrade_pool.add_item(upgrade_axe, 10)	
	
	upgrade_pool.add_item(upgrade_galil, 1)
	upgrade_pool.add_item(upgrade_grenade, 1)
	upgrade_pool.add_item(upgrade_fane, 1)
	upgrade_pool.add_item(upgrade_chicken, 1)
	upgrade_pool.add_item(upgrade_wall, 1)
	upgrade_pool.add_item(upgrade_awp, 1)
	upgrade_pool.add_item(upgrade_rainbow_six, 1)
	upgrade_pool.add_item(upgrade_harddrive, 1)
	
	weapon_pool = [ upgrade_knife, upgrade_glock, upgrade_axe, upgrade_galil,
	 upgrade_grenade, upgrade_fane, upgrade_chicken, upgrade_wall, upgrade_awp,
	 upgrade_rainbow_six, upgrade_harddrive ]
	
	experience_manager.level_up.connect(on_level_up)
	apply_upgrade(GameEvents.current_char.starter_weapon)	
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	if upgrade.is_weapon == true:
		current_weapons += 1	
		
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1,
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity ==  upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)			
			
	
	update_upgrade_pool(upgrade)	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	
		

func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 8)
		upgrade_pool.add_item(upgrade_axe_rate, 8)
	elif chosen_upgrade.id == upgrade_glock.id:
		upgrade_pool.add_item(upgrade_glock_damage, 8)
		upgrade_pool.add_item(upgrade_glock_rate, 8)
	elif chosen_upgrade.id == upgrade_knife.id:
		upgrade_pool.add_item(upgrade_knife_damage, 8)
		upgrade_pool.add_item(upgrade_knife_rate, 8)
	elif chosen_upgrade.id == upgrade_harddrive.id:
		upgrade_pool.add_item(upgrade_harddrive_count, 8)
		upgrade_pool.add_item(upgrade_harddrive_damage, 8)
	elif chosen_upgrade.id == upgrade_galil.id:
		upgrade_pool.add_item(upgrade_galil_damage, 8)
		upgrade_pool.add_item(upgrade_galil_rate, 8)
	elif chosen_upgrade.id == upgrade_grenade.id:
		upgrade_pool.add_item(upgrade_grenade_count, 8)
		upgrade_pool.add_item(upgrade_grenade_damage, 8)
	elif chosen_upgrade.id == upgrade_fane.id:
		upgrade_pool.add_item(upgrade_fane_speed, 8)
		upgrade_pool.add_item(upgrade_fane_damage, 8)
	elif chosen_upgrade.id == upgrade_awp.id:
		upgrade_pool.add_item(upgrade_awp_damage, 8)
		upgrade_pool.add_item(upgrade_awp_rate, 8)
	elif chosen_upgrade.id == upgrade_chicken.id:
		upgrade_pool.add_item(upgrade_chicken_count, 8)
		upgrade_pool.add_item(upgrade_chicken_damage, 8)
	elif chosen_upgrade.id == upgrade_rainbow_six.id:
		upgrade_pool.add_item(upgrade_rainbow_six_rate, 8)
		upgrade_pool.add_item(upgrade_rainbow_six_damage, 8)
	elif chosen_upgrade.id == (upgrade_wall.id):
		upgrade_pool.add_item(upgrade_wall_rate, 8)
		upgrade_pool.add_item(upgrade_wall_damage, 8)
	check_weapons()
	
func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var upgrade_pool_quantity = upgrade_pool.items.size()
	var chosen_upgrades_quantity = chosen_upgrades.size()
	for i in upgrade_pool_quantity:
		if upgrade_pool_quantity == chosen_upgrades_quantity: break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
		
	
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	if upgrade == null:
		return
	apply_upgrade(upgrade)
	

func on_level_up(current_level: int):
	if upgrade_pool.check_empty() == true:
		return
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)

func check_weapons():
	if current_weapons >= 5:
		upgrade_pool.remove_items(weapon_pool)
	print("CurrentWeapons" + " " + str(current_weapons) )
	return
