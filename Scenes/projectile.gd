class_name Projectile
extends Node2D

var is_players := false
var direction := Vector2()
var speed := 60.0
var damage := 2
var pierces := 1
var lifetime := 5.0
var time_lived := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	time_lived += delta
	if time_lived >= lifetime:
		queue_free()

func initialise(_is_players: bool, _direction: Vector2) -> void:
	is_players = _is_players
	direction = _direction


func _physics_process(delta: float) -> void:
	position += (direction * speed * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_players:
		if body is Baddie:
			body.take_damage(damage)
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
