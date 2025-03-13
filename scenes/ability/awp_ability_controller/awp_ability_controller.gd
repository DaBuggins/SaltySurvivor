extends Node

@onready var player = get_tree().get_first_node_in_group("player") as Node2D
@onready var timer: Timer = $Timer


@export var awp_ability_scene: PackedScene
@export var reticule_scene: PackedScene

var base_damage = 10
var additional_damage = 1
var reload_time = 5
var full_upgrade_bonus = 0


func _ready() -> void:
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	timer.timeout.connect(on_timer_timeout)
	timer.wait_time = reload_time
	timer.start()
	
	
func on_timer_timeout():		
	timer.wait_time = reload_time
	timer.start()
	shoot()
	
func shoot():
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return		
	
	var awp_ability = awp_ability_scene.instantiate() as Node2D
	foreground.add_child(awp_ability)
	awp_ability.global_position = player.global_position
	

	
	if ControllerManager.is_using_controller:
		awp_ability.rotation = ControllerManager.get_controller_angle()
	else:
		var mouse_pos = player.get_global_mouse_position() 
		awp_ability.rotation = player.get_angle_to(mouse_pos)
	
	
	awp_ability.hitbox_component.damage = base_damage + additional_damage
	
	var reticule = reticule_scene.instantiate() as Node2D
	reticule.modulate = "yellow"
	player.add_child(reticule)

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "awp_damage":
		additional_damage = (current_upgrades["awp_damage"]["quantity"] * 3)
		full_upgrade_incr(upgrade)
				
	elif upgrade.id == "awp_rate":		
		var percent_reduction = current_upgrades["awp_rate"]["quantity"] * 0.1
		reload_time = reload_time * (1 - percent_reduction)
		full_upgrade_incr(upgrade)
			
func full_upgrade_incr(upgrade: AbilityUpgrade):
		full_upgrade_bonus += 1
		if full_upgrade_bonus == 4:
			GameEvents.full_upgrade.emit(upgrade)
			additional_damage += 5			
			print(self.name + "BONUS UPGRADE DAMAGE APPLIED")
