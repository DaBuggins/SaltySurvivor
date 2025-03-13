extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %MetaUpgradeButton
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel
@onready var upgrade_icon: TextureRect = %UpgradeIcon
@onready var pick_sfx: AudioStreamPlayer = %PickSFX

var upgrade: MetaUpgrade


func _ready() -> void:
	purchase_button.pressed.connect(on_purchase_pressed)

func set_meta_upgrade(new_upgrade: MetaUpgrade):
	self.upgrade = new_upgrade
	name_label.text = new_upgrade.title
	description_label.text = new_upgrade.description
	upgrade_icon.texture = new_upgrade.upgrade_icon
	pick_sfx.stream = new_upgrade.upgrade_sfx

	update_progress()
	
	
func update_progress():
	var current_quantity = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	var is_maxed = current_quantity >= upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"] 
	var percent = min((currency / upgrade.experience_cost), 1)
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "MAX"
	progress_label.text = str(currency) + "/" + str(upgrade.experience_cost)
	count_label.text = "x%d" % current_quantity

func select_card():	
	$AnimationPlayer.play("selected")

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()


	
func on_purchase_pressed():
	if upgrade == null:
		return
	pick_sfx.play()
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")
