extends Resource
class_name Character

@export var id: String
@export var name: String
@export var sprite: Texture
@export_multiline var description: String
@export var speed: float = 100
@export var accel: float = 5
@export var health: float = 5
@export var pickup_area: float = 24
@export var wins: int = 0
@export var unlocked: bool = false
@export var starter_weapon: Ability
@export var pick_sfx: AudioStream
@export var lose_sfx: AudioStream
@export var win_sfx: AudioStream
