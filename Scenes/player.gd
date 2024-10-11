extends CharacterBody2D


const SPEED = 80.0


func _physics_process(delta: float) -> void:
	var dir := Vector2()
	dir.x = Input.get_axis("move_left", "move_right")
	dir.y = Input.get_axis("move_up", "move_down")
	velocity = dir.normalized() * SPEED

	move_and_slide()
