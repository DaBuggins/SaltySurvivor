extends CanvasLayer


@onready var total_vials_label: Label = %TotalVialsLabel
@onready var current_vials_label: Label = %CurrentVialsLabel
@onready var kills_label: Label = %KillsLabel
@onready var kill_sprite: Sprite2D = %KillSprite
@onready var animation_player: AnimationPlayer = $MarginContainer/KillsLabel/KillSprite/AnimationPlayer

var current_kills = 0
var current_vials = 0


func _ready() -> void:
	total_vials_label.text = str(MetaProgression.save_data["meta_upgrade_currency"])
	kills_label.text = str(current_kills)
	if GameEvents.current_char != null:
		kill_sprite.texture = GameEvents.current_char.sprite
	current_vials_label.text = str(current_vials)
	
	GameEvents.enemy_died.connect(on_enemy_died)
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	
func _process(delta: float) -> void:
	pass
	
	
func on_enemy_died():
	current_kills += 1
	kills_label.text = str(current_kills)
	animation_player.play("kill")
	total_vials_label.text = str(MetaProgression.save_data["meta_upgrade_currency"])
	
func on_experience_vial_collected(number: int):
	current_vials += number
	current_vials_label.text = str(current_vials)
	
