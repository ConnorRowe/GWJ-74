extends Player

var steer_dir := false
const centre_pos = Vector2(160, 90)

func _physics_process(_delta: float) -> void:
	if is_instance_valid(nearest_baddie):
		velocity = nearest_baddie.position.direction_to(position).rotated(deg_to_rad(30 if steer_dir else -30)) * speed
	elif (position - centre_pos).length_squared() > 2:
		velocity = position.direction_to(centre_pos) * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_swap_steer_dir_timer_timeout() -> void:
	steer_dir = not steer_dir
