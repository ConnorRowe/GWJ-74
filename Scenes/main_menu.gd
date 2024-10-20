extends Control

const PLAYER_COLOURS := [Color("#222034"), Color("#45283c"), Color("#663931"), Color("#8f563b"),
Color("#df7126"), Color("#fbf236"), Color("#99e550"), Color("#6abe30"), Color("#37946e"),
Color("#323c39"), Color("#3f3f74"), Color("#5b6ee1"), Color("#76428a"), Color("#ac3232"),
Color("#d95763"), Color("#d77bba")]
var player_colour_idx := 8

const BADDIE = preload("res://Scenes/Baddie.tscn")

@onready var fake_player: CharacterBody2D = $FakePlayer
@onready var master_h_slider: HSlider = $MasterHSlider
@onready var music_h_slider: HSlider = $MusicHSlider
@onready var sfx_h_slider: HSlider = $SFXHSlider
var master_bus : int
var music_bus : int
var sfx_bus : int

func _ready() -> void:
	SoundManager.menu_music()
	
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	
	master_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	music_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	sfx_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	
	if not GameInstance.played_intro:
		GameInstance.played_intro = true
		get_tree().paused = true
		$Intro.visible = true
		$Intro/AnimationPlayer.play("intro")

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
	new_baddie.damage = 0
	add_child((new_baddie))


func _on_colour_prev_pressed() -> void:
	player_colour_idx = wrapi(player_colour_idx - 1, 0, len(PLAYER_COLOURS) - 1)
	fake_player.set_player_colour(PLAYER_COLOURS[player_colour_idx])
	GameInstance.player_colour = PLAYER_COLOURS[player_colour_idx]


func _on_colour_next_pressed() -> void:
	player_colour_idx = wrapi(player_colour_idx + 1, 0, len(PLAYER_COLOURS) - 1)
	fake_player.set_player_colour(PLAYER_COLOURS[player_colour_idx])
	GameInstance.player_colour = PLAYER_COLOURS[player_colour_idx]


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_master_h_slider_value_changed(value: float) -> void:
	vol_value_changed(value, master_bus)


func _on_music_h_slider_value_changed(value: float) -> void:
	vol_value_changed(value, music_bus)


func _on_sfxh_slider_value_changed(value: float) -> void:
	vol_value_changed(value, sfx_bus)


func vol_value_changed(vol: float, bus_index: int):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(vol))
	SoundManager.pop()

func intro_unpause() -> void:
	get_tree().paused = false


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$Intro.visible = false
