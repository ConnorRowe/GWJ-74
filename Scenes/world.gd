class_name World
extends Node2D

const SELECTED_STYLE_BOX = preload("res://Assets/SelectedStyleBox.tres")
const BADDIE = preload("res://Scenes/Baddie.tscn")
const SHOOTING_BADDIE = preload("res://Scenes/ShootingBaddie.tscn")
const GEM_GOBLIN = preload("res://Scenes/GemGoblin.tscn")
const GOBLIN_PORTAL = preload("res://Scenes/GoblinPortal.tscn")

@onready var background: TextureRect = $CanvasLayer/Background
@onready var player: Player = $Player
@onready var xp_progress_bar: ProgressBar = $UICanvasLayer/XPBorder/XPProgressBar
@onready var xp_label: Label = $UICanvasLayer/XPLabel
@onready var xp_jiggler: ControlJiggler = $UICanvasLayer/XPBorder/XPJiggler
@onready var level_up_screen: Control = $UICanvasLayer/LevelUpScreen
@onready var option_1: Button = $UICanvasLayer/LevelUpScreen/PanelContainer/VBoxContainer/LevelUpOptions/Option1
@onready var option_2: Button = $UICanvasLayer/LevelUpScreen/PanelContainer/VBoxContainer/LevelUpOptions/Option2
@onready var option_3: Button = $UICanvasLayer/LevelUpScreen/PanelContainer/VBoxContainer/LevelUpOptions/Option3
@onready var option_buttons := [option_1, option_2, option_3]
@onready var ok_button: Button = $"UICanvasLayer/LevelUpScreen/PanelContainer/VBoxContainer/LevelUpOptions/OK Button"
var screen_query : PhysicsShapeQueryParameters2D = null
@onready var arrow: Arrow = $UICanvasLayer/Arrow
@onready var time_label: Label = $UICanvasLayer/TimeLabel
@onready var difficulty_label: RichTextLabel = $UICanvasLayer/DifficultyLabel
@onready var spawn_enemy_timer: Timer = $SpawnEnemyTimer

var player_stats = PlayerStats.new()
var seconds := 0
var minutes := 0

var difficulty := -1

var difficulty_texts = [
	"[wave freq=2.0 amp=10]difficulty: chill",
	"[wave freq=5.0 amp=10][color=#eec39a]difficulty: warming up...",
	"[shake rate=5 level=1][color=#df7126]difficulty: gettin hectic!",
	"[shake rate=10 level=1][color=#d95763]difficulty: quite spicy",
	"[shake rate=20 level=4][color=#ac3232]difficulty: danger!!!"
]

var difficulty_spawn_rates = [
	2.0,
	1.5,
	1.0,
	0.5,
	0.3
]

var pylon_1_repaired := false
var pylon_2_repaired := false
var pylon_3_repaired := false


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
	{
		"title": "Double Attack Speed",
		"code": "x2_atk",
		"icon": preload("res://Assets/Textures/x2.png"),
		"desc": "Attack speed is doubled",
		"weight": 0.5
	},
	{
		"title": "Quad Attack Speed",
		"code": "x4_atk",
		"icon": preload("res://Assets/Textures/x4.png"),
		"desc": "Attack speed is quadrupled",
		"weight": 0.1
	}
]

var level_up_options_backup := []

var max_rng_weight := 0.0
var max_rng_weight_backup := 0.0

var current_options := []

func _ready() -> void:
	SoundManager.theme_music()
	
	for option in level_up_options:
		max_rng_weight += option["weight"]
	
	level_up_options_backup = level_up_options.duplicate(true)
	max_rng_weight_backup = max_rng_weight
	
	player.attack_timer.wait_time = player_stats.attack_speed
	player.world = self
	
	var screen_shape := RectangleShape2D.new()
	screen_shape.size = Vector2(320, 180)
		
	screen_query = PhysicsShapeQueryParameters2D.new()
	screen_query.collide_with_areas = true
	screen_query.collide_with_bodies = false
	screen_query.collision_mask = 2
	screen_query.shape = screen_shape
	
	arrow.player = player
	arrow.goal_point = $Pylon1/PressurePlateSprite.global_position
	
	next_difficulty()


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
	level_up_options = level_up_options_backup.duplicate()

	var options = []
	for i in range(number_of_options):
		options.append(generate_level_up_option())
	
	max_rng_weight = max_rng_weight_backup
	
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
		
	var new_baddie := (BADDIE if randf() > 0.1 else SHOOTING_BADDIE).instantiate()
	new_baddie.position = spawn_pos + player.position
	new_baddie.target = player
	new_baddie.health *= (1 + difficulty)
	new_baddie.xp *= 1 + (difficulty / 2)
	add_child(new_baddie)


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
	
	get_tree().paused = true
	
	open_lvl_up_screen()

func set_option_button(button: Button, option: Dictionary) -> void:
	button.text = option["title"]
	button.icon = option["icon"]
	
func open_lvl_up_screen() -> void:
	level_up_screen.visible = true
	current_options = generate_option_set(3)
	
	SoundManager.level_up()
	
	set_option_button(option_1, current_options[0])
	set_option_button(option_2, current_options[1])
	set_option_button(option_3, current_options[2])

var selected_lvl_up_option := {}
var last_selected_option_button : Button = null

func select_lvl_up_option(index: int) -> void:
	selected_lvl_up_option = current_options[index]
	if is_instance_valid(last_selected_option_button):
		last_selected_option_button.remove_theme_stylebox_override("normal")
		last_selected_option_button.remove_theme_stylebox_override("hover")
	
	if index >= 0:
		last_selected_option_button = option_buttons[index]
		last_selected_option_button.add_theme_stylebox_override("normal", SELECTED_STYLE_BOX)
		last_selected_option_button.add_theme_stylebox_override("hover", SELECTED_STYLE_BOX)
	else:
		last_selected_option_button = null
	
	ok_button.disabled = index < 0
	

func _on_option_1_pressed() -> void:
	select_lvl_up_option(0)
	

func _on_option_2_pressed() -> void:
	select_lvl_up_option(1)


func _on_option_3_pressed() -> void:
	select_lvl_up_option(2)


func _on_ok_button_pressed() -> void:
	apply_selected_lvl_up()


func apply_selected_lvl_up() -> void:
	var code = selected_lvl_up_option["code"]
	
	match code:
		"extra_proj":
			player_stats.number_of_projectiles += 1
		"extra_health":
			player_stats.health += 10
			player.health += 10
			player.health_progress_bar.value += 10
			player.health_progress_bar.max_value = player_stats.health
		"homing_proj":
			player_stats.homing += 1.0
			level_up_options_backup[2]["desc"] = "Projectiles will home in (even more) on enemies"
		"extra_pierce":
			player_stats.pierce += 1
		"bomb":
			player_stats.explode = true
			level_up_options_backup.remove_at(4)
		"x2_range":
			player_stats.reach *= 2
			player.enemy_monitor_shape.radius = player_stats.reach * 4
			player.pickup_shape.radius = player_stats.reach / 2
		"x4_range":
			player_stats.reach *= 4
			player.enemy_monitor_shape.radius = player_stats.reach * 4
			player.pickup_shape.radius = player_stats.reach / 2
		"x2_dmg":
			player_stats.damage *= 2
		"x4_dmg":
			player_stats.damage *= 4
		"x2_atk":
			player_stats.attack_speed *= 0.5
			player.attack_timer.wait_time = player_stats.attack_speed
		"x4_atk":
			player_stats.attack_speed *= 0.25
			player.attack_timer.wait_time = player_stats.attack_speed
		_:
			printerr("ERROR: UNKNOWN LVL UP OPTION CODE")
	
	select_lvl_up_option(-1)
	level_up_screen.visible = false
	get_tree().paused = false


var gem_goblin : GemGoblin = null
@onready var check_screen_timer: Timer = $CheckScreenTimer


func _on_check_screen_timer_timeout() -> void:
	var space_state = get_world_2d().direct_space_state
	screen_query.transform = Transform2D(0, player.position)
	var on_screen_gems = space_state.intersect_shape(screen_query, 16)
	
	if len(on_screen_gems) >= 8:
		#spawn the gem goblin!
		check_screen_timer.stop()
		
		var rand_gem = instance_from_id(on_screen_gems[randi_range(0, len(on_screen_gems) - 1)].collider_id).owner

		var portal = GOBLIN_PORTAL.instantiate()
		add_child(portal)
		portal.position = rand_gem.position + (Vector2(randf(), randf()).normalized() * randf_range(8, 24))
		portal.appear()
		
		await get_tree().create_timer(2, false).timeout

		gem_goblin = GEM_GOBLIN.instantiate()
		gem_goblin.portal = portal
		gem_goblin.position = portal.position
		gem_goblin.dying.connect(on_gem_goblin_dying)
		gem_goblin.dying.connect(portal.disappear)
		add_child(gem_goblin)


func on_gem_goblin_dying() -> void:
	gem_goblin = null
	
	await get_tree().create_timer(20, false).timeout
	check_screen_timer.start()


func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_home"):
		player_stats.number_of_projectiles += 1


func _on_runtime_timer_timeout() -> void:
	seconds += 1
	if seconds >= 60:
		seconds = 0
		minutes += 1
		next_difficulty()
	
	time_label.text = "%02d:%02d" % [minutes, seconds]

func next_difficulty() -> void:
	if difficulty >= 4:
		return
	
	difficulty += 1
	difficulty_label.text = difficulty_texts[difficulty]
	spawn_enemy_timer.wait_time = difficulty_spawn_rates[difficulty]
	

func next_pylon_arrow() -> void:
	var next_pylon : Node = null
	if not pylon_1_repaired:
		next_pylon = $Pylon1
	elif not pylon_2_repaired:
		next_pylon = $Pylon2
	elif not pylon_3_repaired:
		next_pylon = $Pylon3
	else:
		# Game complete!
		game_won()
		return
	
	arrow.goal_point = next_pylon.get_node("PressurePlateSprite").global_position

func _on_pylon_1_repaired() -> void:
	pylon_1_repaired = true
	next_pylon_arrow()


func _on_pylon_3_repaired() -> void:
	pylon_3_repaired = true
	next_pylon_arrow()


func _on_pylon_2_repaired() -> void:
	pylon_2_repaired = true
	next_pylon_arrow()

func game_won() -> void:
	spawn_enemy_timer.stop()
	player.invulnerable = true
	
