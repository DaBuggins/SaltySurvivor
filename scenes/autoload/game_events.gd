extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged
signal play_pressed
signal run_ended
signal win(winner: Character, current_level: String)
signal lose
signal enemy_died
signal player_healed(heal_amount: float)
signal char_selected
signal stop_music
signal start_music
signal final_xp(number: float)
signal loss_xp(number: float)
signal disable_back
signal flag_collected
signal end_boss_killed
signal full_upgrade(upgrade: AbilityUpgrade)


var current_char: Character
var current_vials: float = 0
var current_level_id: String 
var collected_flags: Array



func emit_experience_vial_collected(number: float):
	current_vials += number
	experience_vial_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	print("UPGRADE: " + str(upgrade.name) + "   CURRENT UPGRADES: " + str(current_upgrades))
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_player_damaged():
	player_damaged.emit()
	
func emit_player_healed(heal_amount: float):
	player_healed.emit(heal_amount)

func emit_play_pressed():
	play_pressed.emit()

func emit_run_ended():	
	run_ended.emit()

	
func emit_char_selected(chosen_char: Character):	
	current_char = chosen_char
	MetaProgression.update_current_char(chosen_char)
	char_selected.emit(chosen_char)
	
func get_current_char():
	return current_char
	
func emit_enemy_died():
	enemy_died.emit()

func emit_win(winner: Character, current_level: String):
	win.emit(current_char, current_level_id)

func emit_lose(loser: Character):
	lose.emit(current_char)

func emit_stop_music():
	stop_music.emit()

func emit_start_music():
	start_music.emit()

func emit_final_xp(final_vials: float):
	final_xp.emit(current_vials)
	current_vials = 0

func emit_loss_xp(final_vials: float):
	loss_xp.emit(floor(current_vials / 2))
	current_vials = 0

func emit_disable_back():
	disable_back.emit()

func emit_flag_collected(flag_number: int):
	print("COLLECTED FLAG:  " + str(flag_number))
	collected_flags.append(flag_number)
	flag_collected.emit(flag_number)

func emit_end_boss_killed():
	end_boss_killed.emit()
	
func emit_full_upgrade(upgrade: AbilityUpgrade):
	full_upgrade.emit()
