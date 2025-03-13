extends Sprite2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	cursor(player)
	
func cursor(player: Node2D):	
	var mouse_pos = player.get_global_mouse_position()

	global_position = player.position.lerp(mouse_pos, 0.1)
