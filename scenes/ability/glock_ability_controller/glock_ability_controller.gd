extends Node

@export var glock_ability_scene: PackedScene


var base_damage = 3
var base_wait_time = 1.5
var additional_damage = 1
var rotation = 0	
var is_rotated = false	
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
		

	
	var glock_instance = glock_ability_scene.instantiate() as Node2D
	if is_rotated:
		glock_instance.scale.y *= -1
	foreground.add_child(glock_instance)
	glock_instance.rotate(deg_to_rad(rotation))
	
	
	rotation += 180
	if !is_rotated:
		is_rotated = true
	else:
		is_rotated = false

	glock_instance.global_position = player.global_position 
	glock_instance.hitbox_component.damage = base_damage + additional_damage
	glock_instance.hitbox_component_2.damage = base_damage + additional_damage
	glock_instance.hitbox_component_3.damage = base_damage + additional_damage
	

		

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "glock_damage":
		additional_damage = 1 + (current_upgrades["glock_damage"]["quantity"] * 3)
		full_upgrade_incr(upgrade)
	elif upgrade.id == "glock_rate":
		var percent_reduction = current_upgrades["glock_rate"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
		full_upgrade_incr(upgrade)

func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			additional_damage += 4
			print(self.name + "BONUS UPGRADE DAMAGE APPLIED")
