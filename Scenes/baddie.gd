class_name Baddie
extends CharacterBody2D

@export var health := 4
@export var speed := 50.0
@export var damage := 1
const MOVE_DIST := 120.0
const CONTACT_DMG_TIME := .25

var target : CharacterBody2D = null
var in_contact_range := false
var contact_damage_counter := 0.0
@onready var damage_jiggler: Jiggler = $Sprite2D/DamageJiggler

func _enter_tree() -> void:
	target = get_node("../Player")

func _process(delta: float) -> void:
	if in_contact_range:
		contact_damage_counter -= delta
		
		if contact_damage_counter <= 0:
			target.take_damage(damage)
			contact_damage_counter = CONTACT_DMG_TIME

func _physics_process(delta: float) -> void:
	
	if is_equal_approx(speed, 0):
		return
	
	
	if target.position.distance_squared_to(position) > MOVE_DIST:
		velocity = (target.position - position).normalized() * speed
		in_contact_range = false
	else:
		velocity = Vector2()
		in_contact_range = true

	move_and_slide()

func take_damage(amount: int) -> void:
	health = clampi(health - amount, 0, 100)
	damage_jiggler.jiggle(1)
	if health <= 0:
		queue_free()
