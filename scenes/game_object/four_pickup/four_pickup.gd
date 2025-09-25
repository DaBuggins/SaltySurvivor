extends Node2D


@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var four_pickup_ability: Node2D = $FourPickupAbility
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)
	
func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return	

	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))
	

func collect():	
	four_pickup_ability.play_ability()
	queue_free()
	
	
func disable_collision():
	collision_shape_2d.disabled = true

func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred()
	four_pickup_ability.play_ability()
	

	animation_player.play("special_pickup")
