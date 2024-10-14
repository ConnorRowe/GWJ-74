extends Node2D

const BADDIE = preload("res://Scenes/Baddie.tscn")
const SHOOTING_BADDIE = preload("res://Scenes/ShootingBaddie.tscn")
@onready var background: TextureRect = $CanvasLayer/Background
@onready var player: Player = $Player
@onready var xp_progress_bar: ProgressBar = $UICanvasLayer/XPBorder/XPProgressBar
@onready var xp_label: Label = $UICanvasLayer/XPLabel
@onready var xp_jiggler: ControlJiggler = $UICanvasLayer/XPBorder/XPJiggler
@onready var level_up_screen: Control = $UICanvasLayer/LevelUpScreen
@onready var option_1: Button = $UICanvasLayer/LevelUpScreen/PanelContainer/VBoxContainer/LevelUpOptions/Option1
@onready var option_2: Button = $UICanvasLayer/LevelUpScreen/PanelContainer/VBoxContainer/LevelUpOptions/Option2
@onready var option_3: Button = $UICanvasLayer/LevelUpScreen/PanelContainer/VBoxContainer/LevelUpOptions/Option3

var level_up_options := [
	{
		"title": "+1 Projectile",
		"code": "extra_proj",
		"icon": preload("res://Assets/Textures/extra_proj.png"),
		"desc": "Shoot an extra projectile with each attack",
		"weight": 0.2
	},
	{
		"title": "+10 Health",
		"code": "extra_health",
		"icon": preload("res://Assets/Textures/health.png"),
		"desc": "10 extra health points",
		"weight": 3
	},
	{
		"title": "Homing Projectiles",
		"code": "homing_proj",
		"icon": preload("res://Assets/Textures/homing.png"),
		"desc": "Projectiles will home in on enemies",
		"weight": 0.1
	},
	{
		"title": "+1 Pierce",
		"code": "extra_pierce",
		"icon": preload("res://Assets/Textures/pierce.png"),
		"desc": "Projectiles will pierce through enemies an extra time",
		"weight": 0.4
	},
	{
		"title": "Bomb",
		"code": "bomb",
		"icon": preload("res://Assets/Textures/bomb.png"),
		"desc": "Projectiles explode in an area on hit",
		"weight": 0.1
	},
	{
		"title": "Double Range",
		"code": "x2_range",
		"icon": preload("res://Assets/Textures/x2.png"),
		"desc": "Everything has x2 range",
		"weight": 1
	},
	{
		"title": "Quad Range",
		"code": "x4_range",
		"icon": preload("res://Assets/Textures/x4.png"),
		"desc": "Everything has x4 range",
		"weight": 0.1
	},
	{
		"title": "Double Damage",
		"code": "x2_dmg",
		"icon": preload("res://Assets/Textures/x2.png"),
		"desc": "All damage is doubled",
		"weight": 0.5
	},
	{
		"title": "Quad Damage",
		"code": "x4_dmg",
		"icon": preload("res://Assets/Textures/x4.png"),
		"desc": "All damage is quadrupled",
		"weight": 0.1
	},
]

var level_up_options_backup := []

var max_rng_weight := 0.0
var max_rng_weight_backup := 0.0

var current_options := []

func _ready() -> void:
	for option in level_up_options:
		max_rng_weight += option["weight"]
	
	level_up_options_backup = level_up_options.duplicate(true)
	max_rng_weight_backup = max_rng_weight


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_home"):
		open_lvl_up_screen()

func generate_level_up_option() -> Dictionary:
	var weight = randf() * max_rng_weight
	var cur_weight := 0.0
	for option in level_up_options:
		cur_weight += option["weight"]
		if weight <= cur_weight:
			level_up_options.erase(option)
			max_rng_weight -= option["weight"]
			return option
	
	return level_up_options[1]


func generate_option_set(number_of_options: int) -> Array:
	var options = []
	for i in range(number_of_options):
		options.append(generate_level_up_option())
	
	max_rng_weight = max_rng_weight_backup
	level_up_options = level_up_options_backup.duplicate()
	
	return options


func _physics_process(_delta: float) -> void:
	background.material.set_shader_parameter("player_position", player.position)


func spawn_enemy() -> void:
	var spawn_pos = Vector2()
	if randf() > 0.5:
		spawn_pos.x = randf_range(-160, 160)
		spawn_pos.y =  -90 if randf() > 0.5 else 90
	else:
		spawn_pos.x = -160 if randf() > 0.5 else 160
		spawn_pos.y = randf_range(-90, 90)
		
	var new_baddie = (BADDIE if randf() > 0.1 else SHOOTING_BADDIE).instantiate()
	new_baddie.position = spawn_pos + player.position
	new_baddie.target = player
	add_child((new_baddie))


func _on_spawn_enemy_timer_timeout() -> void:
	spawn_enemy()


func _on_player_xp_changed(new_xp: int) -> void:
	xp_progress_bar.value = new_xp
	xp_jiggler.jiggle(0.1)


func _on_player_lvl_up(current_xp: int, next_xp_req: int, new_lvl: int) -> void:
	xp_progress_bar.value = current_xp
	xp_progress_bar.max_value = next_xp_req
	xp_label.text = str(new_lvl)
	xp_jiggler.jiggle(1)

func set_option_button(button: Button, option: Dictionary) -> void:
	button.text = option["title"]
	button.icon = option["icon"]
	
func open_lvl_up_screen() -> void:
	level_up_screen.visible = true
	current_options = generate_option_set(3)
	
	set_option_button(option_1, current_options[0])
	set_option_button(option_2, current_options[1])
	set_option_button(option_3, current_options[2])



func _on_option_1_pressed() -> void:
	pass # Replace with function body.


func _on_option_2_pressed() -> void:
	pass # Replace with function body.


func _on_option_3_pressed() -> void:
	pass # Replace with function body.


func _on_ok_button_pressed() -> void:
	pass # Replace with function body.
