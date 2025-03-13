extends TextureRect

@onready var bonus_1: GridContainer = $Bonus1
@onready var bonus_2: GridContainer = $Bonus2
@onready var full_upgrade_particles: GPUParticles2D = %FullUpgradeParticles

@onready var upgrade_id: String
@export var bonus_icon: PackedScene

func _ready() -> void:
	pass

func add_bonus1_icon():
	var bonus_icon_instance = bonus_icon.instantiate() as TextureRect
	bonus_1.add_child(bonus_icon_instance)
	check_full_upgrade()

func add_bonus2_icon():
	var bonus_icon_instance = bonus_icon.instantiate() as TextureRect
	bonus_2.add_child(bonus_icon_instance)
	check_full_upgrade()

func set_upgrade_id(upgrade):
	upgrade_id = upgrade.id
	print("UPGRADE ID:  " + str(upgrade_id))

func check_full_upgrade():
	if bonus_1.get_child_count() == 2 && bonus_2.get_child_count() == 2:
		full_upgrade_particles.emitting = true
