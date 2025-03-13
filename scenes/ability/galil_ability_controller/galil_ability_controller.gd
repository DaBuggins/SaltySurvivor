extends Node

@export var galil_ability_scene: PackedScene
const GALIL_ABILITY = preload("res://scenes/ability/galil_ability/galil_ability.tscn")

var base_damage = 3
var additional_damage = 1
var rotation = 45		
var is_rotated = false	
var reload_time = 1
var full_upgrade_bonus = 0

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)	

	
func on_timer_timeout():
	$Timer.wait_time = reload_time
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var galil_instance = galil_ability_scene.instantiate() as Node2D
	if is_rotated:
		galil_instance.scale.y *= -1
	foreground.add_child(galil_instance)
	galil_instance.rotate(deg_to_rad(rotation))
	rotation += 90
	is_rotated = true
	galil_instance.global_position = player.global_position 
	galil_instance.hitbox_component.damage = base_damage + additional_damage
	galil_instance.hitbox_component_2.damage = base_damage + additional_damage
	galil_instance.hitbox_component_3.damage = base_damage + additional_damage

		

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "galil_damage":
		additional_damage = (current_upgrades["galil_damage"]["quantity"] * 3)
		full_upgrade_incr(upgrade)
	elif upgrade.id == "galil_rate":
		reload_time = 1 - (current_upgrades["galil_rate"]["quantity"] * .1)
		full_upgrade_incr(upgrade)

func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			additional_damage += 4
			print(self.name + "BONUS UPGRADE DAMAGE APPLIED")
