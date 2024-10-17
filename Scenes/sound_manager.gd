extends Node

@onready var pop_player: AudioStreamPlayer = $PopPlayer
@onready var hurt_player: AudioStreamPlayer = $HurtPlayer
@onready var wobble_player: AudioStreamPlayer = $WobblePlayer
@onready var baddie_hit_player: AudioStreamPlayer = $BaddieHitPlayer

func pop() -> void:
	pop_player.play()


func hurt() -> void:
	hurt_player.play()


func wobble() -> void:
	wobble_player.play()

func baddie_hit() -> void:
	baddie_hit_player.play()
