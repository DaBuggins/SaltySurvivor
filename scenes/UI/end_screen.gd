extends CanvasLayer

@onready var panel_container = %PanelContainer
@onready var char_sprite: Sprite2D = $CharSprite
@onready var char_animation_player: AnimationPlayer = $CharAnimationPlayer
@onready var confetti_explode: GPUParticles2D = %ConfettiExplode


func _ready() -> void:	
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	GameEvents.emit_run_ended()
	

	
	
	%ContinueButton.pressed.connect(on_continue_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)
	
	
func set_defeat():
	var current_char = GameEvents.current_char
	var current_vials = GameEvents.current_vials	
	GameEvents.emit_loss_xp(current_vials)
	GameEvents.emit_lose(current_char)		
	
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You Died"
	
	char_sprite.texture = current_char.sprite	
	char_animation_player.play("explode")
	
func set_victory():
	var current_char = GameEvents.current_char
	var current_vials = GameEvents.current_vials
	confetti_explode.restart()
	
	GameEvents.emit_final_xp(current_vials)
	GameEvents.emit_win(current_char, GameEvents.current_level_id)
	char_sprite.texture = current_char.sprite
		

func on_continue_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/end_meta_menu.tscn")
	
func on_quit_button_pressed():
	GameEvents.emit_run_ended()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")


	
