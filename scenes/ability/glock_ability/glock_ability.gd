extends Node2D


@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hitbox_component_2: HitboxComponent = $HitboxComponent2
@onready var hitbox_component_3: HitboxComponent = $HitboxComponent3

@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var glock_aimer: Sprite2D = %GlockAimer


func _ready() -> void:
	animation_player.play("shoot_glock")
	await animation_player.animation_finished
	queue_free()
	
func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	glock_aimer.global_position = player.global_position
