extends Resource
class_name AbilityUpgrade

@export var id: String
@export var parent_id: String
@export var bonus_slot: int = 1
@export var max_quantity: int
@export var name: String
@export var sprite: Texture
@export var is_weapon = true
@export var color: Color = "white"
@export_multiline var description: String
