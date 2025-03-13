extends Node2D

const MAX_RADIUS = 800
	
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var sprite_2d: Sprite2D = $Sprite2D


@export var health_pickup_scene: PackedScene

var base_rotation = Vector2.RIGHT
var egg_chance = 0.1
var enemy: Node2D

func _ready() -> void:
	audio_stream_player_2d.play()
	%ShotParticle.restart()
	
	get_enemy()		
	if enemy == null:
		return
	var enemy_angle =  self.global_position.angle_to(enemy.global_position)
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	self.global_position = player.global_position
	var sprite_rotation = sprite_2d.rotation
	self.rotation = self.global_position.angle_to(enemy.global_position)
	sprite_2d.rotation = -self.global_position.angle_to(enemy.global_position)
	animation_player.play("shoot_chicken")

func lay_egg():	
	animation_player.play("lay_anim")
	if randf() <= egg_chance:
		var health_pickup = health_pickup_scene.instantiate() as Node2D	
		get_tree().get_first_node_in_group("foreground_layer").add_child.call_deferred(health_pickup)
		health_pickup.global_position = global_position
	return
	

func get_enemy():
	enemy = get_tree().get_nodes_in_group("enemy").pick_random()

		
	
