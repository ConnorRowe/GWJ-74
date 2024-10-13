extends Node2D

const BADDIE = preload("res://Scenes/Baddie.tscn")
const SHOOTING_BADDIE = preload("res://Scenes/ShootingBaddie.tscn")
@onready var background: TextureRect = $CanvasLayer/Background
@onready var player: Player = $Player
@onready var xp_progress_bar: ProgressBar = $CanvasLayer/XPBorder/XPProgressBar
@onready var xp_label: Label = $CanvasLayer/XPLabel
@onready var xp_jiggler: ControlJiggler = $CanvasLayer/XPBorder/XPJiggler


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
