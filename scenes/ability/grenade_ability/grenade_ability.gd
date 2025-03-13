extends Node2D

const MAX_RADIUS = 100


@onready var hitbox_component = $HitboxComponent

var base_damage = 4
var addtional_damage_percent = 1
