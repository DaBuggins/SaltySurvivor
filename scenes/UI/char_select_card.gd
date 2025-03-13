extends PanelContainer


@onready var name_label: Label = %NameLabel
@onready var health_icon_label: Label = %HealthIconLabel
@onready var speed_icon_label: Label = %SpeedIconLabel
@onready var accel_icon_label: Label = %AccelIconLabel
@onready var starter_icon: TextureRect = %StarterIcon
@onready var level_1_particles: GPUParticles2D = %Level1Particles
@onready var level_2_particles: GPUParticles2D = %Level2Particles
@onready var level_3_particles: GPUParticles2D = %Level3Particles


@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var disabled_overlay: ColorRect = %DisabledOverlay
@onready var salt_select_effect: GPUParticles2D = $SaltSelectEffect

@onready var focus_button: Button = %FocusButton



var disabled = false
var chosen_char: Character

func _ready() -> void:		

	focus_button.focus_entered.connect(on_focus_entered)
	focus_button.focus_exited.connect(on_focus_exited)
	focus_button.pressed.connect(on_button_pressed)
	
	
		
func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	scale = Vector2.ZERO
	await get_tree().create_timer(delay).timeout
	
	$AnimationPlayer.play("in")
	
func play_discard():
	$AnimationPlayer.play("discard")

func set_char(char_set: Character):
	name_label.text = char_set.name
	health_icon_label.text = str(char_set.health)
	speed_icon_label.text = str(char_set.speed)
	accel_icon_label.text = str(char_set.accel)
	starter_icon.texture = char_set.starter_weapon.sprite
	sprite_2d.texture = char_set.sprite
	

	chosen_char = char_set
	self_modulate = char_set.starter_weapon.color
	if MetaProgression.save_data["char_progress"][chosen_char.id]["is_unlocked"] == false:
		disabled = true
		disabled_overlay.visible = true
	if MetaProgression.save_data["char_progress"][chosen_char.id]["levels"]["level1"]["boss_killed"] == true:
		level_1_particles.emitting = true
	if MetaProgression.save_data["char_progress"][chosen_char.id]["levels"]["level2"]["boss_killed"] == true:
		level_2_particles.emitting = true
	if MetaProgression.save_data["char_progress"][chosen_char.id]["levels"]["level3"]["boss_killed"] == true:
		level_3_particles.emitting = true
		


func select_char(selected_char: Character):
	GameEvents.emit_char_selected(selected_char)
	GameEvents.disable_back.emit()
	disabled = true
	$AnimationPlayer.play("selected")	
	
	for other_card in get_tree().get_nodes_in_group("char_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await animation_player.animation_finished	

	load_main() 	


func on_button_pressed():
	if disabled:
		return

	select_char(chosen_char)	
	
func on_focus_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
	salt_select_effect.restart()
	
func on_focus_exited():
	release_focus()	

	
func load_main():
	get_tree().change_scene_to_file("res://scenes/UI/level_select.tscn")
