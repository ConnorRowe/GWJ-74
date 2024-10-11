extends CharacterBody2D

const SPEED = 50.0

var target : CharacterBody2D = null

func _enter_tree() -> void:
	target = get_node("../Player")

func _physics_process(delta: float) -> void:
	velocity = (target.position - position).normalized() * SPEED

	move_and_slide()
