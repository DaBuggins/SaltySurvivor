extends Node

@export var harddrive_ability_scene: PackedScene

const BASE_RANGE = 100
const BASE_DAMAGE = 8

var additional_damage = 1
var harddrive_count = 0
var full_upgrade_bonus = 0

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))	
	var additional_rotation_degress = 360.0 / (harddrive_count + 1)
	var anvil_distance = randf_range(5, BASE_RANGE)
	for i in harddrive_count + 1:		
		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_rotation_degress))
		var spawn_position = player.global_position + (adjusted_direction * anvil_distance)

		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)	
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if !result.is_empty():
			spawn_position = result["position"]
			
		var harddrive_ability = harddrive_ability_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(harddrive_ability)
		harddrive_ability.global_position = spawn_position
		harddrive_ability.hitbox_component.damage = BASE_DAMAGE + additional_damage
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "harddrive_count":
		harddrive_count = current_upgrades["harddrive_count"]["quantity"]
		full_upgrade_incr(upgrade)
	elif upgrade.id == "harddrive_damage":
		additional_damage = current_upgrades["harddrive_damage"]["quantity"] * 4
		full_upgrade_incr(upgrade)
		
func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			additional_damage += 5
			print(self.name + "   BONUS UPGRADE DAMAGE APPLIED")
