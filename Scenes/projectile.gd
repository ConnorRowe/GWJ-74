class_name Projectile
extends Node2D

const EXPLOSION = preload("res://Scenes/Explosion.tscn")

var is_players := false
var direction := Vector2()
var speed := 45.0
var damage := 2
var pierces := 1
var lifetime := 5.0
var time_lived := 0.0
var homing := 0.0
@onready var homing_area_2d: Area2D = $HomingArea2D
@onready var homing_area_shape: CircleShape2D = $HomingArea2D/CollisionShape2D.shape
var target : Node2D = null
var explode := false
var reach := 0.0

var nearby_targets : Array[CharacterBody2D] = []

func _process(delta: float) -> void:
	time_lived += delta
	if time_lived >= lifetime:
		queue_free()

func initialise(_is_players: bool, _direction: Vector2, _player_stats: PlayerStats) -> void:
	is_players = _is_players
	direction = _direction
	lifetime = _player_stats.reach * 0.1
	damage = _player_stats.damage
	pierces = _player_stats.pierce
	homing = _player_stats.homing
	explode = _player_stats.explode
	reach = _player_stats.reach
	
	$HomingArea2D.monitoring = homing > 0
	$HomingArea2D/CollisionShape2D.shape.radius = _player_stats.reach * 4
	if homing > 0:
		if not is_node_ready():
			await self.ready
		$CheckNearestTargetTimer.start()

func _physics_process(delta: float) -> void:
	if homing > 0 && is_instance_valid(target):
		direction = direction.move_toward(position.direction_to(target.position), delta * homing * 40)
	
	position += (direction * speed * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_players:
		if body is Baddie:
			if explode:
				var explosion = EXPLOSION.instantiate()
				explosion.explode(damage, reach)
				explosion.position = position
				add_sibling(explosion)
			else:
				body.take_damage(damage)
				SoundManager.baddie_hit()
			
			pierces -= 1
	elif body is Player:
		body.take_damage(damage)
		pierces -= 1
	
	if pierces <= 0:
		queue_free()


func set_projectile_colours(colour_a: Color, colour_b: Color):
	var mtl : ShaderMaterial = $Sprite2D.material
	mtl.set_shader_parameter("colour_a", colour_a)
	mtl.set_shader_parameter("colour_b", colour_b)


func _on_homing_area_2d_body_entered(body: Node2D) -> void:
	var applicable = (is_players and body is Player) or (not is_players and body is Baddie)
	
	if applicable:
		nearby_targets.append(applicable)
		if len(nearby_targets) == 1:
			target = applicable


func _on_homing_area_2d_body_exited(body: Node2D) -> void:
	nearby_targets.erase(body)


func _on_check_nearest_target_timer_timeout() -> void:
	if len(nearby_targets) == 1:
			target = nearby_targets[0]
			return
	
	var nearest : CharacterBody2D = null
	var nearest_dist := 99999999.9
	
	var bad_chars = []
	
	for nearby : CharacterBody2D in nearby_targets:
		if not is_instance_valid(nearby):
			bad_chars.append(nearby)
			continue
			
		var dist = nearby.position.distance_squared_to(position)
		if dist < nearest_dist:
			nearest = nearby
			nearest_dist = dist
	
	for bad_char in bad_chars:
		nearby_targets.erase(bad_char)
	
	target = nearest
