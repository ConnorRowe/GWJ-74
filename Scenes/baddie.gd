class_name Baddie
extends CharacterBody2D

const GEM = preload("res://Scenes/Gem.tscn")

@export var health := 4
@export var speed := 25.0
@export var damage := 1
@export var xp := 1
const MOVE_DIST := 120.0
const CONTACT_DMG_TIME := .25

var target : CharacterBody2D = null
var in_contact_range := false
var contact_damage_counter := 0.0
@onready var damage_jiggler: Jiggler = $Sprite2D/DamageJiggler

func _process(delta: float) -> void:
	if in_contact_range:
		contact_damage_counter -= delta
		
		if contact_damage_counter <= 0:
			target.take_damage(damage)
			contact_damage_counter = CONTACT_DMG_TIME

func _physics_process(_delta: float) -> void:
	
	if is_equal_approx(speed, 0) or not is_instance_valid(target):
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
		call_deferred("die")

func die() -> void:
	# Spawn xp gem
	var gem = GEM.instantiate()
	gem.initialise(xp)
	gem.position = position
	add_sibling(gem)
	queue_free()
	
