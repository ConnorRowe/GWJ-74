extends Node2D

var shape_cast_2d: ShapeCast2D
var animated_sprite_2d: AnimatedSprite2D


func explode(damage: int, reach: float) -> void:
	shape_cast_2d = $ShapeCast2D
	animated_sprite_2d = $AnimatedSprite2D
	
	var radius = 14.0 * (reach * 0.1)
	shape_cast_2d.shape.radius = radius
	animated_sprite_2d.scale = Vector2(radius / 14.0, radius / 14.0)
	animated_sprite_2d.play()
	
	await self.ready
	
	shape_cast_2d.force_shapecast_update()
	for collision in shape_cast_2d.collision_result:
		var collider = instance_from_id(collision["collider_id"])
		if collider is Baddie:
			collider.take_damage(damage)


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
