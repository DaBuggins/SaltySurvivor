extends Node

signal using_controller
signal using_mouse
signal auto_pick

var is_using_controller = false
var using_auto_pick = false

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if is_using_controller == false:		
			emit_using_controller()
			
	if event.is_action_pressed("right_stick_motion"):
		if is_using_controller == false:		
			emit_using_controller()
	#if event is InputEventJoypadMotion:
		#if is_using_controller == false:		
			#emit_using_controller()
			
	if event is InputEventMouseButton:		
		emit_using_mouse()
		
	if event is InputEventMouseMotion:
		emit_using_mouse()

func emit_using_controller():
	#print("//USING CONTROLLER//")
	is_using_controller = true
	using_controller.emit()
	
func emit_using_mouse():
	#print("//USING MOUSE//")
	is_using_controller = false
	using_mouse.emit()
	
func emit_auto_pick():
	using_auto_pick = not using_auto_pick
	auto_pick.emit(using_auto_pick)

func get_controller_angle():
	var controllerangle = Vector2.ZERO
	var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var yAxisUD = Input.get_joy_axis(0 ,JOY_AXIS_RIGHT_Y)
	controllerangle = Vector2(xAxisRL, yAxisUD).angle()
	var rotation = controllerangle
	return rotation
