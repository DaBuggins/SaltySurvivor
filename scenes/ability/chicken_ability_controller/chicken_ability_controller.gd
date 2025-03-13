extends Node

@export var chicken_ability_scene: PackedScene

@export var chicken_count = 1
@export var chicken_damage = 4

var chicken_rotation = 0
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
	
	for i in chicken_count:
		var chicken_ability = chicken_ability_scene.instantiate() as Node2D
		foreground.add_child(chicken_ability)		
		chicken_ability.global_position = player.global_position		
		chicken_ability.hitbox_component.damage = chicken_damage
		
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "chicken_count":
		chicken_count += current_upgrades["chicken_count"]["quantity"]
		full_upgrade_incr(upgrade)
	elif upgrade.id == "chicken_damage":
		chicken_damage += current_upgrades["chicken_damage"]["quantity"] * 3
		full_upgrade_incr(upgrade)

func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			chicken_damage += 5
			print(self.name + "BONUS UPGRADE DAMAGE APPLIED")

	
