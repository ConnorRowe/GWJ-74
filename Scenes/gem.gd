class_name Gem
extends Node2D

var xp := 1

func initialise(_xp: int) -> void:
	xp = _xp
	
	if xp >= 10 and xp < 50:
		$Sprite2D.material.set_shader_parameter("replace_colour", Color("#6abe30"))
	elif xp >= 50:
		$Sprite2D.material.set_shader_parameter("replace_colour", Color("#ac3232"))
