extends CharacterBody2D

const MAX_SPEED = 200
const ACCLERATION_SMOOTHING = 25


@export var arena_time_manager: Node

@onready var hit_sound_player: AudioStreamPlayer2D = $HitSoundPlayer
@onready var damage_interval_timer = $DamangeIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component: Node = $VelocityComponent
@onready var sprite: Sprite2D = %Sprite2D
@onready var pickup_area_shape: CollisionShape2D = %PickupAreaShape

@onready var player_death_component: Node2D = $PlayerDeathComponent


var number_colliding_bodies = 0
var base_speed = 100
var pickup_area: float = 24


var current_char: Character

func _ready() -> void:
	if arena_time_manager:
		arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)	
	
	base_speed = velocity_component.max_speed
	if GameEvents.get_current_char() != null:
		current_char = GameEvents.get_current_char()
		sprite.texture = current_char.sprite
		base_speed = current_char.speed
		velocity_component.max_speed = base_speed
		velocity_component.acceleration = current_char.accel
		health_component.max_health = current_char.health
		health_component.current_health = current_char.health
		pickup_area = current_char.pickup_area
		
	var pickup_area_bonus = MetaProgression.get_upgrade_count("perm_pickup_radius")
	pickup_area_shape.shape.radius = pickup_area + pickup_area_bonus	
		
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	GameEvents.player_healed.connect(on_player_healed)
	
	
	GameEvents.ability_upgrade_added.emit(current_char.starter_weapon, {})
	update_health_display()


func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func get_movement_vector():	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)

func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()
	
	
func update_health_display():
	if health_bar.value > .2:
		health_bar.value = health_component.get_health_percent()
	else:
		health_bar.value = health_component.get_health_percent() - .1 

func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1

func on_damage_interval_timer_timeout():
	check_deal_damage()

func on_health_decreased():
	GameEvents.emit_player_damaged()
	visuals.modulate = Color(0,0,0,.5)
	hit_sound_player.play_random()	
	var tween = create_tween()
	tween.tween_property(visuals, "modulate", Color(1,1,1,1), .5 )
	
func on_health_changed():
	update_health_display()
	
func on_player_healed(heal_amount):
	health_component.heal(heal_amount)

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1) 
	elif ability_upgrade.id == "pickup_radius":
		%PickupAreaShape.shape.radius = pickup_area * (current_upgrades["pickup_radius"]["quantity"] * 2)
		#+ (current_upgrades["pickup_radius"]["quantity"] * 40)
	
		
func on_arena_difficulty_increased(difficulty: int):
	var health_regen_quantity = MetaProgression.get_upgrade_count("health_regen")
	if health_regen_quantity > 0:
		var is_thirty_second_interval = (difficulty % 6) == 0
		if is_thirty_second_interval:
			health_component.heal(health_regen_quantity) 
