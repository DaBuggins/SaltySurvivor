extends Sprite2D

func _physics_process(delta: float) -> void:
	if ControllerManager.is_using_controller:
		var controllerangle = Vector2.ZERO
		var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var yAxisUD = Input.get_joy_axis(0 ,JOY_AXIS_RIGHT_Y)
		controllerangle = Vector2(xAxisRL, yAxisUD).angle()
		rotation = controllerangle
	else:
		var player = get_tree().get_first_node_in_group("player") as Node2D
		if player == null:
			return
			
		mouse_cursor(player)

func mouse_cursor(player: Node2D):	
	var mouse_pos = player.get_global_mouse_position()
	var mouse_angle = get_angle_to(mouse_pos) 
	rotate(mouse_angle)


	
