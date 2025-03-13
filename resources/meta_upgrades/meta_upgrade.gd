extends Resource
class_name MetaUpgrade

@export var id: String
@export var max_quantity: int = 1
@export var experience_cost: int = 10
@export var unlock: bool = false
@export var title: String	
@export_multiline var description: String
@export var upgrade_icon: Texture
@export var upgrade_sfx: AudioStream
