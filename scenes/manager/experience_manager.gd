extends Node

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 4

var current_experience = 0
var target_experience = 1
var leftover_experience = 0

var current_level = 1

var exp_modifier = 1



func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	

func _process(delta: float) -> void:
	%ExpLabel.text = str("current: " + str(current_experience))
	%ExpLabel2.text = str("target: " + str(target_experience))
	%ExpLabel4.text = str("LEVEL: " + str(current_level))

func increment_experience(number: float):
	if number + current_experience >= target_experience:
		leftover_experience = number + current_experience - target_experience
	current_experience = min(current_experience + number, target_experience)

		
	experience_updated.emit(current_experience, target_experience)

	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH + exp_modifier
		current_experience = 0
		if leftover_experience:
			current_experience = min((target_experience - 1), leftover_experience )
			leftover_experience = 0
		experience_updated.emit(current_experience, target_experience)
		level_up.emit(current_level)	
		exp_modifier += 1
	
	
func on_experience_vial_collected(number: float):
	increment_experience(number)
