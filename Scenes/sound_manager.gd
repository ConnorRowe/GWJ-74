extends Node

const GWJ_74_MENU = preload("res://Assets/Music/GWJ74_Menu.ogg")
const GWJ_74_THEME = preload("res://Assets/Music/GWJ74_Theme.ogg")
const DEAD = preload("res://Assets/Samples/Dead.wav")
const LEVEL_UP = preload("res://Assets/Samples/Level_up.wav")
const GOBLIN_GIGGLE = preload("res://Assets/Samples/Goblin-giggle.wav")

@onready var pop_player: AudioStreamPlayer = $PopPlayer
@onready var hurt_player: AudioStreamPlayer = $HurtPlayer
@onready var wobble_player: AudioStreamPlayer = $WobblePlayer
@onready var baddie_hit_player: AudioStreamPlayer = $BaddieHitPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var explosion_player: AudioStreamPlayer = $ExplosionPlayer
@onready var pylon_player: AudioStreamPlayer = $PylonPlayer
@onready var other_player: AudioStreamPlayer = $OtherPlayer
func pop() -> void:
	pop_player.play()


func hurt() -> void:
	hurt_player.play()


func wobble() -> void:
	wobble_player.play()


func baddie_hit() -> void:
	baddie_hit_player.play()

func explode() -> void:
	explosion_player.play()

func menu_music() -> void:
	if music_player.stream != GWJ_74_MENU:
		music_player.stream = GWJ_74_MENU
		music_player.play()


func theme_music() -> void:
	music_player.stream = GWJ_74_THEME
	music_player.play()

func pylon() -> void:
	pylon_player.play()

func level_up() -> void:
	other_player.stream = LEVEL_UP
	other_player.play()

func game_over() -> void:
	other_player.stream = DEAD
	other_player.play()

func goblin() -> void:
	other_player.stream = GOBLIN_GIGGLE
	other_player.play()
