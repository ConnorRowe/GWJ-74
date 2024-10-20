extends Node

var player_colour := Color(0.216, 0.58, 0.431)

var played_intro := false

func _input(event: InputEvent) -> void:
	if event.is_action_released("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
