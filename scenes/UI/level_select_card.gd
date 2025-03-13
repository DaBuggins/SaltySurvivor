extends PanelContainer


@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var disabled_overlay: ColorRect = %DisabledOverlay
@onready var preview_image: Sprite2D = %PreviewImage
@onready var salt_select_effect: GPUParticles2D = $SaltSelectEffect
@onready var focus_button: Button = %FocusButton


var disabled = false
var chosen_level: Level
var level_chosen = false

func _ready() -> void:
	#gui_input.connect(on_gui_input)
	
	focus_button.focus_entered.connect(on_focus_entered)
	focus_button.focus_exited.connect(on_focus_exited)
	focus_button.pressed.connect(on_button_pressed)
	#mouse_entered.connect(on_mouse_entered)
		
func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	scale = Vector2.ZERO
	await get_tree().create_timer(delay).timeout	
	$AnimationPlayer.play("in")
	
func play_discard():
	$AnimationPlayer.play("discard")

func set_level(chosen_level_card: Level):
	MetaProgression.check_level_data(chosen_level_card.id)
	name_label.text = chosen_level_card.name
	description_label.text = chosen_level_card.description
	preview_image.texture = chosen_level_card.preview_image
	chosen_level = chosen_level_card
	
	if chosen_level_card.id == "level1":
		focus_button.grab_focus()
	elif chosen_level_card.id == "level2":
		if MetaProgression.save_data["level_progress"]["level1"]["level_beaten"] == false:
			disabled = true
			focus_button.disabled = true
			focus_button.button_disabled()
	elif chosen_level_card.id == "level3":
		if MetaProgression.save_data["level_progress"]["level2"]["level_beaten"] == false:
			disabled = true
			focus_button.disabled = true
			focus_button.button_disabled()


func select_level(selected_level: Level):
	MusicPlayer.char_select_player.stop()
	GameEvents.disable_back.emit()
	disabled = true
	$AnimationPlayer.play("selected")	
	
	for other_card in get_tree().get_nodes_in_group("char_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await animation_player.animation_finished
	#get_tree().paused = false
	load_level(selected_level) 	

#func on_gui_input(event: InputEvent):
	#if disabled:
		#return
		#
	#if event.is_action_pressed("left_click"):
		#select_level(chosen_level)

#func on_mouse_entered():
	#if disabled:
		#return
	#$HoverAnimationPlayer.play("hover")
	#salt_select_effect.restart()
	

func on_focus_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
	salt_select_effect.restart()
	
func on_focus_exited():
	release_focus()
	
func on_button_pressed():
	if level_chosen == true:
		return
	select_level(chosen_level)
	level_chosen = true
	
func load_level(selected_level: Level):
	var level_path = selected_level.level_scene.resource_path		
	get_tree().change_scene_to_file(level_path)
