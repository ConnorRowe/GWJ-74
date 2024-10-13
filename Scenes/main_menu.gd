extends Control

const PLAYER_COLOURS := [Color("#222034"), Color("#45283c"), Color("#663931"), Color("#8f563b"),
Color("#df7126"), Color("#fbf236"), Color("#99e550"), Color("#6abe30"), Color("#37946e"),
Color("#323c39"), Color("#3f3f74"), Color("#5b6ee1"), Color("#76428a"), Color("#ac3232"),
Color("#d95763"), Color("#d77bba")]
var player_colour_idx := 8

const BADDIE = preload("res://Scenes/Baddie.tscn")
@onready var fake_player: CharacterBody2D = $FakePlayer

func _on_spawn_enemy_timer_timeout() -> void:
	var spawn_pos = Vector2()
	if randf() > 0.5:
		spawn_pos.x = randf_range(0, 320)
		spawn_pos.y =  0 if randf() > 0.5 else 180
	else:
		spawn_pos.x = 0 if randf() > 0.5 else 320
		spawn_pos.y = randf_range(0, 180)
		
	var new_baddie = BADDIE.instantiate()
	new_baddie.position = spawn_pos
	new_baddie.target = fake_player
	add_child((new_baddie))


func _on_colour_prev_pressed() -> void:
	player_colour_idx = wrapi(player_colour_idx - 1, 0, len(PLAYER_COLOURS) - 1)
	fake_player.set_player_colour(PLAYER_COLOURS[player_colour_idx])


func _on_colour_next_pressed() -> void:
	player_colour_idx = wrapi(player_colour_idx + 1, 0, len(PLAYER_COLOURS) - 1)
	fake_player.set_player_colour(PLAYER_COLOURS[player_colour_idx])
