extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D
@export var death_sfx: AudioStream

@onready var death_sfx_player: AudioStreamPlayer2D = %DeathSFXPlayer




func _ready() -> void:
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)
	death_sfx_player.stream = death_sfx
	
	
func on_died():
	$GPUParticles2D.texture = sprite.texture
	GameEvents.emit_enemy_died()
	death_sfx_player.stream = death_sfx
	death_sfx_player.play()
	if owner == null || not owner is Node2D:
		return
		
	var spawn_position = owner.global_position
	
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	
	global_position = spawn_position
	$AnimationPlayer.play("default")
	$HitRandomAudioPlayer2DComponent.play_random()
	
