extends Node

@onready var pop_player: AudioStreamPlayer = $PopPlayer
@onready var hurt_player: AudioStreamPlayer = $HurtPlayer
@onready var wobble_player: AudioStreamPlayer = $WobblePlayer

func pop() -> void:
	pop_player.play()


func hurt() -> void:
	hurt_player.play()


func wobble() -> void:
	wobble_player.play()
