class_name Baddie
extends CharacterBody2D

const GEM = preload("res://Scenes/Gem.tscn")

signal dying

@export var health := 4
@export var speed := 25.0
@export var damage := 1
@export var xp := 1
const MOVE_DIST := 120.0
const CONTACT_DMG_TIME := .25

@export var target : CharacterBody2D = null
var in_contact_range := false
var contact_damage_counter := 0.0
@export var despawns := true
@onready var damage_jiggler: Jiggler = $Sprite2D/DamageJiggler
@onready var offscreen_timer: Timer = $OffscreenTimer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	if health <= 0:
		return
	
	if in_contact_range:
		contact_damage_counter -= delta
		
		if contact_damage_counter <= 0:
			target.take_damage(damage)
			contact_damage_counter = CONTACT_DMG_TIME
	
	if velocity.length_squared() > 0:
		sprite_2d.flip_h = velocity.x > 0

func _physics_process(_delta: float) -> void:
	
	if health <= 0 or is_equal_approx(speed, 0) or not is_instance_valid(target):
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
	dying.emit()
	
	$CollisionShape2D.disabled = true
	
	# Animate dying
	var death_tween = create_tween().set_parallel()
	death_tween.tween_property($Shadow.material, "shader_parameter/fade_amount", 1.0, .5)
	death_tween.tween_property(sprite_2d.material, "shader_parameter/fade_amount", 1.0, .5)
	
	# Spawn XP gem
	var gem = GEM.instantiate()
	gem.initialise(xp)
	gem.position = position
	add_sibling(gem)
	gem.bounce()
	
	# Wait til anim is finished then free node
	await death_tween.finished
	death_tween.stop()
	
	queue_free()


## Despawn after being off-screen for 5 secs
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	offscreen_timer.start()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	offscreen_timer.stop()


func _on_offscreen_timer_timeout() -> void:
	if despawns:
		queue_free()
