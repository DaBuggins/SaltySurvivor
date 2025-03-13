extends Button


@onready var name_label: Label = %NameLabel
@onready var health_icon_label: Label = %HealthIconLabel
@onready var speed_icon_label: Label = %SpeedIconLabel
@onready var accel_icon_label: Label = %AccelIconLabel
@onready var starter_icon: TextureRect = %StarterIcon


@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var disabled_overlay: ColorRect = %DisabledOverlay
@onready var salt_select_effect: GPUParticles2D = $SaltSelectEffect





var is_disabled = false
var chosen_char: Character

func _ready() -> void:	
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
	
		
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
		is_disabled = true
		disabled = true
		disabled_overlay.visible = true
		


func select_char(selected_char: Character):
	GameEvents.emit_char_selected(selected_char)
	is_disabled = true
	$AnimationPlayer.play("selected")	
	
	for other_card in get_tree().get_nodes_in_group("char_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await animation_player.animation_finished
	

	load_main() 	

func on_gui_input(event: InputEvent):
	if is_disabled:
		return		

	#if event.is_action_pressed("left_click") or event.is_action_pressed("ui_accept"):
		#select_char(chosen_char)
	
func on_button_pressed():
	if is_disabled:
		return
	select_char(chosen_char)

	
	
func on_mouse_entered():
	if is_disabled:
		return
	grab_focus()
	$HoverAnimationPlayer.play("hover")
	salt_select_effect.restart()
	
func on_mouse_exited():
	release_focus()

	

	
func load_main():
	get_tree().change_scene_to_file("res://scenes/UI/level_select.tscn")
