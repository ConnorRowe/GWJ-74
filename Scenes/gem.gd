class_name Gem
extends Node2D

var xp := 1

func initialise(_xp: int) -> void:
	xp = _xp
	
	if xp >= 10 and xp < 50:
		$Sprite2D.material.set_shader_parameter("replace_colour", Color("#6abe30"))
	elif xp >= 50:
		$Sprite2D.material.set_shader_parameter("replace_colour", Color("#ac3232"))

func bounce() -> void:
	var bounce_tween := create_tween()
	bounce_tween.set_parallel()
	var sprite_2d: Sprite2D = $Sprite2D
	var sprite_rise_tween = bounce_tween.tween_property(sprite_2d, "position", Vector2(0, -16), 0.2)
	sprite_rise_tween.set_ease(Tween.EASE_OUT)
	var sprite_bounce_tween = bounce_tween.tween_property(sprite_2d, "position", Vector2.ZERO, 1.0)
	sprite_bounce_tween.from(Vector2(0, -16))
	sprite_bounce_tween.set_trans(Tween.TRANS_BOUNCE)
	sprite_bounce_tween.set_ease(Tween.EASE_OUT)
	sprite_bounce_tween.set_delay(0.2)
	
	var slide_tween = bounce_tween.tween_property(self, "position", position + (Vector2(randf(), randf()).normalized() * 16), 2.0)
	slide_tween.from(position)
	slide_tween.set_trans(Tween.TRANS_CUBIC)
	slide_tween.set_ease(Tween.EASE_OUT)
	
