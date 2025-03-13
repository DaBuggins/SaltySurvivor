extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var upgrade_image: TextureRect = %UpgradeImage
@onready var focus_button: Button = %FocusButton
@onready var salt_select_effect: GPUParticles2D = $SaltSelectEffect

var disabled = false

func _ready() -> void:
	focus_button.focus_entered.connect(on_focus_entered)
	focus_button.focus_exited.connect(on_focus_exited)	
	focus_button.pressed.connect(on_button_pressed)
	
func _process(delta: float) -> void:
	
	if focus_button.is_hovered():
		focus_button.grab_focus()

	
func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	scale = Vector2.ZERO
	await get_tree().create_timer(delay).timeout
	
	$AnimationPlayer.play("in")
	
func play_discard():
	$AnimationPlayer.play("discard")

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	upgrade_image.texture = upgrade.sprite
	self.self_modulate = upgrade.color

func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	selected.emit()


		
func on_button_pressed():
	select_card()

func on_focus_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
	salt_select_effect.restart()
	
func on_focus_exited():
	release_focus()	

#func on_mouse_entered():
	#if disabled:
		#return
	#grab_focus()
	#$HoverAnimationPlayer.play("hover")
	#
#func on_mouse_exited():
	#release_focus()
