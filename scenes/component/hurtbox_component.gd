extends Area2D
class_name HurtboxComponent

signal  hit

@export var health_component: HealthComponent

var floating_text_scene = preload("res://scenes/UI/floating_text.tscn")
var damage_mult: float = 0
var updated_damage: float
var original_damage: float

func _ready() -> void:
	area_entered.connect(on_area_entered)
	if MetaProgression.get_upgrade_count("damage_mult") != 0:
		damage_mult = (MetaProgression.get_upgrade_count("damage_mult"))
	
	var enemy_node = get_parent() as CharacterBody2D
	if enemy_node == null:
		return
	enemy_node.safe_margin = 3	
	
func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
		
	if health_component == null:
		return
		
	
	var hitbox_component = other_area as HitboxComponent	
	original_damage = hitbox_component.damage
	updated_damage = (hitbox_component.damage + damage_mult)
	
	hitbox_component.damage = updated_damage
	health_component.damage(hitbox_component.damage)
	
	var floating_text = floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	
	var format_string =  "%0.0f"
	#if round(hitbox_component.damage) == hitbox_component.damage:
		#format_string = "%0.0f"
	if hitbox_component.damage == 0:
		floating_text.start("")
	else:
		floating_text.start(format_string % hitbox_component.damage)
	hitbox_component.damage = original_damage
	hit.emit()
