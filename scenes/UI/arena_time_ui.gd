extends CanvasLayer


@export var arena_time_manager: Node
@onready var label = %Label

func _process(delta: float) -> void:
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	var current_difficulty = arena_time_manager.get_current_difficulty()
	var countdown = (arena_time_manager.timer.wait_time - time_elapsed)
	label.text = format_seconds_to_string(countdown) + "    DIFFICULTY:   " + str(current_difficulty)


func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60)
	minutes = int(minutes)
	var remaining_seconds = seconds - (minutes * 60)
	remaining_seconds = int(remaining_seconds)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
	
