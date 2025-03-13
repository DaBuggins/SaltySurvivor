extends Node

@export var wall_ability_scene: PackedScene
@export var reticule_scene: PackedScene
@onready var timer: Timer = $Timer

var base_damage = 5
var additional_damage = 1	
var reload_time = 3
var full_upgrade_bonus = 0

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)	

	
func on_timer_timeout():
	timer.wait_time = reload_time
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return		
	
	var wall_ability = wall_ability_scene.instantiate() as Node2D
	foreground.add_child(wall_ability)
	wall_ability.global_position = player.global_position
	
	if ControllerManager.is_using_controller:
		wall_ability.rotation = ControllerManager.get_controller_angle()
	else:
		var mouse_pos = player.get_global_mouse_position() 
		wall_ability.rotation = player.get_angle_to(mouse_pos)


	wall_ability.hitbox_component.damage = base_damage + additional_damage
	
	var reticule = reticule_scene.instantiate() as Node2D
	reticule.modulate = "brown"
	player.add_child(reticule)

		

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "wall_damage":
		additional_damage = (current_upgrades["wall_damage"]["quantity"] * 3)
		full_upgrade_incr(upgrade)
	elif upgrade.id == "wall_rate":
		reload_time = 3 - (current_upgrades["wall_rate"]["quantity"] * 0.5)
		full_upgrade_incr(upgrade)

func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			additional_damage += 4
			print(self.name + "   BONUS UPGRADE DAMAGE APPLIED")
