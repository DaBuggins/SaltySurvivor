extends CanvasLayer

signal back_pressed

@export var upgrades: Array[MetaUpgrade] = []

@onready var back_button: Button = %BackButton
@onready var grid_container = %GridContainer
@onready var total_vials_label: Label = %TotalVialsLabel

var meta_upgrade_card_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")


func _ready() -> void:
	back_button.pressed.connect(on_back_pressed)
 
	for child in grid_container.get_children():
		child.queue_free()	
	

	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)
	
	

func _process(delta: float) -> void:
		total_vials_label.text = str(MetaProgression.save_data["meta_upgrade_currency"])

func on_back_pressed():	
		back_pressed.emit()
	
	
