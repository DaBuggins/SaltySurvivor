extends Node2D

const MAX_RADIUS = 800
	
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var hitbox_component: HitboxComponent = %HitboxComponent
@export var health_pickup_scene: PackedScene

var base_rotation = Vector2.RIGHT
var egg_chance = 0.05
var enemy: Node2D

func _ready() -> void:
	audio_stream_player_2d.play()
	
	enemy = get_tree().get_nodes_in_group("enemy").pick_random()
		

	%ShotParticle.restart()
	if enemy == null:
		return


	var tween = create_tween()
	tween.tween_property(self, "global_position", enemy.global_position, 2.5).set_ease(Tween.EASE_IN)
	#tween.tween_property(self, "global_position", self.global_position.lerp(new_pos, 0.3), 2.5).set_ease(Tween.EASE_IN)
	tween.tween_callback(lay_egg)
	tween.tween_callback(queue_free).set_delay(2)			


func lay_egg():	
	animation_player.play("lay_anim")
	if randf() <= egg_chance:
		var health_pickup = health_pickup_scene.instantiate() as Node2D	
		get_tree().get_first_node_in_group("foreground_layer").add_child.call_deferred(health_pickup)
		health_pickup.global_position = global_position
	return
	

	
	
	
	#var enemy_array = get_tree().get_nodes_in_group("enemy").duplicate() as Array[Node2D]
	#var close_enemies: Array[Node2D]
	#
	#if enemy_array == null:
		#return
	#for e in enemy_array:
		#var distance_to_enemy = self.global_position.distance_to(e.global_position)	
		#print(distance_to_enemy)
		#if distance_to_enemy < 500:
			#close_enemies.append(e)			
		#else:
			#var idx = enemy_array.find(e)
			#enemy_array.remove_at(idx)
		#
#
	#
	#enemy = close_enemies.pick_random()
	#var new_enemy = get_tree().get_nodes_in_group("enemy").pick_random() as Node2D
	#var distance_to_enemy = self.global_position.distance_to(new_enemy.global_position)
	#if new_enemy == null:
		#return		
	#
	#if distance_to_enemy > 400:
		#queue_free()

	
		
	
