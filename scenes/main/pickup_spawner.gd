extends Node

@export var health_pickup: PackedScene

func _ready() -> void:
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	if ability_upgrade.id == "health_up":
		drop_health(player)
		

func drop_health(player: Node2D):
	var health_drop = health_pickup.instantiate() as Node2D
	get_tree().get_first_node_in_group("entities_layer").add_child(health_drop)
	health_drop.global_position = player.global_position + Vector2(50,-50)
