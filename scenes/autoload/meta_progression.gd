extends Node

const SAVE_FILE_PATH = "user://game.save"
@export var chars: Array[Character]= []

var save_data: Dictionary = {
	"meta_upgrade_currency": 100,
	"meta_upgrades": {},
	"current_char": {},
	"char_progress": {},
	"level_progress": {}
	
}

func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	GameEvents.final_xp.connect(save_final_xp)
	GameEvents.loss_xp.connect(save_loss_xp)
	GameEvents.win.connect(on_win)
	GameEvents.enemy_died.connect(on_enemy_died)
	GameEvents.end_boss_killed.connect(on_end_boss_killed)
	
	load_save_file()
		
	
func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		for c in chars:
			check_create(c)					
		return		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	
	
func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data) 
		

func add_meta_upgrade(upgrade: MetaUpgrade):
	if upgrade.unlock == true:
		save_data["char_progress"][upgrade.id]["is_unlocked"] = true
		save_data["meta_upgrades"][upgrade.id] = {
				"quantity": 0 
			}		
	else:
		if !save_data["meta_upgrades"].has(upgrade.id):
			save_data["meta_upgrades"][upgrade.id] = {
				"quantity": 0 
			}		
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	
	save()
	
	
func get_upgrade_count(upgrade_id: String):
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0
	
	
func get_current_char():
	return save_data["current_char"]
	
func update_current_char(chosen_char: Character):	
	check_create(chosen_char)
	save_data["current_char"] = chosen_char
	save_data["char_progress"][chosen_char.id]["pick_count"] += 1		
	save()	
	

func on_experience_collected(number: int):
	#save_data["meta_upgrade_currency"] += number
	pass
	
func on_enemy_died():
	var curr_char = save_data["current_char"].id
	var char_save = save_data["char_progress"][curr_char]
	char_save["enemies_killed"] += 1
	#print("ENEMIES KILLED: " + str(char_save["enemies_killed"]) )
	
func save_final_xp(number: int):
	save_data["meta_upgrade_currency"] += number
	
func save_loss_xp(number: int):
	save_data["meta_upgrade_currency"] += number

func on_win(current_char: Character, current_level: String):
	var char_save = save_data["char_progress"][current_char.id]
	char_save["levels"][current_level]["wins"] += 1
	char_save["win_count"] += 1
	print(str(save_data["char_progress"][current_char.id]["levels"]))
	check_level_data(current_level)
	save_data["level_progress"][current_level]["level_beaten"] = true
	print("LEVEL PROGRESS:   " + str(save_data["level_progress"]))
		
func on_end_boss_killed():	
	var current_level_id = GameEvents.current_level_id
	var char_save = save_data["char_progress"][GameEvents.current_char.id]
	char_save["levels"][current_level_id]["boss_killed"] = true
	char_save["levels"][current_level_id]["times_boss_killed"] += 1
	check_level_data(current_level_id)
	save_data["level_progress"][current_level_id]["level_beaten"] = true
	save_data["level_progress"][current_level_id]["end_boss_beaten"] = true
	
	

func check_create(chosen_char: Character):
	if !save_data["char_progress"].has(chosen_char.id):
		save_data["char_progress"][chosen_char.id] = {
				"is_unlocked": chosen_char.unlocked,
				 "win_count": 0,
				 "pick_count": 0,
				"starter_weapon": PackedScene,
				"levels": {
					"level1": {"wins": 0, "boss_killed": false, "times_boss_killed": 0 },
					"level2": {"wins": 0, "boss_killed": false, "times_boss_killed": 0 },
					"level3": {"wins": 0, "boss_killed": false, "times_boss_killed": 0 },
				},
				"enemies_killed": 0,
				"bosses_killed": 0,
				 
			}	

func check_level_data(chosen_level):
	if !save_data["level_progress"].has(chosen_level):
		save_data["level_progress"][chosen_level] = {
			"level_beaten": false,
			"end_boss_beaten": false,
			
		}
