extends CanvasLayer

@onready var flag_0: TextureRect = $MarginContainer/VBox/Flag0
@onready var flag_1: TextureRect = $MarginContainer/VBox/Flag1
@onready var flag_2: TextureRect = $MarginContainer/VBox/Flag2
@onready var flag_3: TextureRect = $MarginContainer/VBox/Flag3
@onready var salt_explode: GPUParticles2D = %SaltExplode
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var number_flags_collected = 0

func _ready() -> void:	
	GameEvents.flag_collected.connect(on_flag_collected)
	
	
func on_flag_collected(flag_number):
	print(flag_number)
	if flag_number == 0:
		flag_0.visible = true
		number_flags_collected += 1
	elif flag_number == 1:
		flag_1.visible = true
		number_flags_collected += 1
	elif flag_number == 2:
		flag_2.visible = true
		number_flags_collected += 1
	elif flag_number == 3:
		flag_3.visible = true
		number_flags_collected += 1
		
	if number_flags_collected >= 4:
		salt_explode.restart()
		animation_player.play("expand_and_fade")
		print("4 FLAGS COLLECTED!!!")
