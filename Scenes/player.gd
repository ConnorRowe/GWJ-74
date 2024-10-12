class_name Player
extends CharacterBody2D

const PROJECTILE = preload("res://Scenes/Projectile.tscn")

var health: int = 100
const SPEED = 80.0
@onready var health_progress_bar: ProgressBar = $ColorRect/HealthProgressBar
var nearby_baddies := []
var nearest_baddie : Baddie = null
@onready var movement_jiggler: Node = $SpriteExtraParent/Sprite2D/MovementJiggler
@onready var damage_jiggler: Node = $SpriteExtraParent/DamageJiggler
@onready var blood_particles: CPUParticles2D = $BloodParticles

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var dir := Vector2()
	dir.x = Input.get_axis("move_left", "move_right")
	dir.y = Input.get_axis("move_up", "move_down")
	velocity = dir.normalized() * SPEED

	move_and_slide()


func attack() -> void:
	var projectile = PROJECTILE.instantiate()
	projectile.initialise(true, position.direction_to(nearest_baddie.position))
	add_sibling(projectile)
	projectile.position = position


func take_damage(amount: int) -> void:
	health = clampi(health - amount, 0, 100)
	health_progress_bar.value = health
	damage_jiggler.jiggle(.5)
	blood_particles.emitting = true


func _on_enemy_monitor_area_2d_body_entered(body: Node2D) -> void:
	if body is Baddie:
		nearby_baddies.append(body)


func _on_enemy_monitor_area_2d_body_exited(body: Node2D) -> void:
	if body is Baddie:
		nearby_baddies.erase(body)


func _on_check_nearest_baddie_timer_timeout() -> void:
	var nearest_dist := 9999999.0
	for i in range(len(nearby_baddies)):
		var baddie = nearby_baddies[i]
		if not is_instance_valid(baddie):
			nearby_baddies.erase(baddie)
			continue
			
		var dist := position.distance_squared_to(baddie.position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_baddie = baddie


func _on_attack_timer_timeout() -> void:
	if is_instance_valid(nearest_baddie):
		attack()


func _on_move_jiggle_timer_timeout() -> void:
	if velocity.length() > 0:
		movement_jiggler.jiggle(0.5)
