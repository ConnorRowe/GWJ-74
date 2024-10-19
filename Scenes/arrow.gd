class_name Arrow
extends Sprite2D

var goal_point := Vector2.ZERO
var player: Player = null

func _process(_delta: float) -> void:
	rotation = player.position.angle_to_point(goal_point)
	material.set_shader_parameter("target_closeness", clampf(player.position.distance_squared_to(goal_point) / 40000, 0, 1))
