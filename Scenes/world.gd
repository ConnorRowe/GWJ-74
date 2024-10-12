extends Node2D

const BADDIE = preload("res://Scenes/Baddie.tscn")
const SHOOTING_BADDIE = preload("res://Scenes/ShootingBaddie.tscn")
@onready var background: TextureRect = $CanvasLayer/Background
@onready var player: Player = $Player


func _physics_process(delta: float) -> void:
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
	add_child((new_baddie))


func _on_spawn_enemy_timer_timeout() -> void:
	spawn_enemy()
