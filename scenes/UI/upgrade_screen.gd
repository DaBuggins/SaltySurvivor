extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer

func _ready() -> void:
	if ControllerManager.using_auto_pick == false:
		get_tree().paused = true
	

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		if card_container.get_child_count() < 3:
			var card_instance = upgrade_card_scene.instantiate()
			card_container.add_child(card_instance)
			card_instance.set_ability_upgrade(upgrade)
			card_instance.play_in(delay)
			card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
			if ControllerManager.using_auto_pick == false:
				delay += .2
	card_container.get_child(0).focus_button.grab_focus()
	if ControllerManager.using_auto_pick == true:
		card_container.get_children().pick_random().select_card()
	
func on_upgrade_selected(upgrade: AbilityUpgrade):	
	upgrade_selected.emit(upgrade)
	if ControllerManager.using_auto_pick == false:
		$AnimationPlayer.play("out")
		await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
