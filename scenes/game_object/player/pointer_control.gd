extends Node
@onready var pointer: Sprite2D = $Pointer

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	cursor(player)
	
func cursor(player: Node2D):	
	var mouse_pos = player.position


	pointer.rotation = player.get_angle_to(mouse_pos)
	#global_rotation = player.global_position.angle_to(mouse_pos)
