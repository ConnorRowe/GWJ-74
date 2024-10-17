class_name Player
extends CharacterBody2D

signal xp_changed(new_xp)
signal lvl_up(current_xp, next_xp_req, new_lvl)

const PROJECTILE = preload("res://Scenes/Projectile.tscn")

var health := 100
var xp := 0
var lvl := 1
var xp_req = 10
const SPEED = 40.0
var nearby_baddies := []
var nearest_baddie : Baddie = null
@onready var health_progress_bar: ProgressBar = $HealthBorder/HealthProgressBar
@onready var movement_jiggler: Jiggler = $SpriteExtraParent/BodySprite/MovementJiggler
@onready var damage_jiggler: Node = $SpriteExtraParent/DamageJiggler
@onready var blood_particles: CPUParticles2D = $BloodParticles
@onready var body_sprite: Sprite2D = $SpriteExtraParent/BodySprite
@onready var attack_timer: Timer = $AttackTimer
@onready var enemy_monitor_shape: CircleShape2D = $EnemyMonitorArea2D/CollisionShape2D.shape
var world: World = null
const attack_offset = Vector2(0, -4)

func _input(event: InputEvent) -> void:
	return
	if event.is_action_pressed("ui_home"):
		add_xp(xp_req - xp)

func _physics_process(_delta: float) -> void:
	var dir := Vector2()
	dir.x = Input.get_axis("move_left", "move_right")
	dir.y = Input.get_axis("move_up", "move_down")
	velocity = dir.normalized() * SPEED

	move_and_slide()
	
func _draw() -> void:
	return
	if is_instance_valid(nearest_baddie):
		draw_line(Vector2.ZERO, Vector2.from_angle(position.angle_to_point(nearest_baddie.position)) * 64, Color.DARK_RED, 3)
		draw_line(Vector2.ZERO, position.direction_to(nearest_baddie.position) * 64, Color.DARK_BLUE, 2)
		draw_line(Vector2.ZERO, Vector2.from_angle(position.direction_to(nearest_baddie.position).angle()) * 64, Color.DARK_GREEN)
	else:
		draw_circle(Vector2.ZERO, enemy_monitor_shape.radius, Color.BROWN)

func attack() -> void:
	var stats = world.player_stats if is_instance_valid(world) else PlayerStats.new()
	var separation := deg_to_rad(5)
	var target_angle := position.angle_to_point(nearest_baddie.position)
	
	if stats.number_of_projectiles % 2 == 0:
		target_angle -= separation / 2.0
		target_angle -= separation * (stats.number_of_projectiles / 2)
	elif stats.number_of_projectiles > 1:
		target_angle -= separation * ((stats.number_of_projectiles - 1) / 2)
	
	for i in range(stats.number_of_projectiles):
		var projectile = PROJECTILE.instantiate()		
		projectile.initialise(true, Vector2.from_angle(target_angle), stats)
		target_angle += separation
		
		add_sibling(projectile)
		projectile.position = position + attack_offset


func take_damage(amount: int) -> void:
	health = clampi(health - amount, 0, 100)
	health_progress_bar.value = health
	damage_jiggler.jiggle(.5)
	blood_particles.emitting = true
	SoundManager.hurt()

func set_body_colour(colour: Color) -> void:
	body_sprite.material.set_shader_parameter("fill_colour", colour)

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


func set_player_colour(colour: Color) -> void:
	body_sprite.material.set_shader_parameter("fill_colour", colour)


func _on_pickup_area_2d_area_entered(area: Area2D) -> void:
	# Pick up something
	var area_parent = area.get_parent()
	if area_parent is Gem:
		add_xp(area_parent.xp)
		SoundManager.pop()
		area_parent.queue_free()


func add_xp(_xp: int) -> void:
	xp += _xp
	xp_changed.emit(xp)
	
	if(xp >= xp_req):
		lvl += 1
		xp -= xp_req
		xp_req *= 1.5
		lvl_up.emit(xp, xp_req, lvl)
