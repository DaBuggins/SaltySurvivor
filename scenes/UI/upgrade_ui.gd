extends CanvasLayer


@export var upgrade_icon: PackedScene
@export var speed_icon: Texture2D
@export var pickup_icon: Texture2D
@onready var icon_container: GridContainer = $MarginContainer/IconContainer
@onready var speed_bonus_container: HBoxContainer = $MarginContainer/VFlowContainer/SpeedBonusContainer
@onready var pickup_bonus_container: HBoxContainer = $MarginContainer/VFlowContainer/PickupBonusContainer

@onready var full_upgrade_sprite: Sprite2D = $NotifLabel/FullUpgradeSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:	
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	GameEvents.full_upgrade.connect(on_full_upgrade)
	
	
func _process(delta: float) -> void:
	pass
	
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):	
	
	if current_upgrades.size() <= 0:
		return
		
	if upgrade.is_weapon:
		var upgrade_icon_instance = upgrade_icon.instantiate() as TextureRect
		upgrade_icon_instance.texture = upgrade.sprite
		upgrade_icon_instance.set_upgrade_id(upgrade)
		icon_container.add_child(upgrade_icon_instance)
	else:
		if upgrade.id == "player_speed":
			var speed_icon_instance = upgrade_icon.instantiate() as TextureRect
			speed_icon_instance.texture = speed_icon
			speed_bonus_container.add_child(speed_icon_instance)
		elif upgrade.id == "pickup_radius":
			var pickup_icon_instance = upgrade_icon.instantiate() as TextureRect
			pickup_icon_instance.texture = pickup_icon
			pickup_bonus_container.add_child(pickup_icon_instance)
		for i in icon_container.get_children():
			if upgrade.parent_id == i.upgrade_id:
				if upgrade.bonus_slot == 1:
					i.add_bonus1_icon()					
				elif upgrade.bonus_slot == 2:
					i.add_bonus2_icon()


func on_full_upgrade(upgrade: AbilityUpgrade):
	full_upgrade_sprite.texture = upgrade.sprite
	animation_player.play("expand_and_fade")
