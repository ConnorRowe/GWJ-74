extends Node2D

const EXPLOSION = preload("res://Scenes/Explosion.tscn")

signal repaired()

@onready var beam_start: AnimatedSprite2D = $BeamStart
@onready var beam_repeat: AnimatedSprite2D = $BeamRepeat
@onready var pylon_sprite: Sprite2D = $PylonSprite
@onready var pressure_plate_sprite: Sprite2D = $PressurePlateSprite
@onready var jiggler: Jiggler = $PylonSprite/Jiggler

var explosion_locations : Array[Vector2] = []
var is_repaired := false


func _ready() -> void:
	for child : Marker2D in $ExplosionLocations.get_children():
		explosion_locations.append(child.global_position)


func _on_pressure_plate_area_2d_body_entered(body: Node2D) -> void:
	if not is_repaired and body is Player:
		repair()


func repair() -> void:
	is_repaired = true
	
	pressure_plate_sprite.frame = 1
	
	SoundManager.wobble()
	
	var explosion_delay := 0.6
	
	for pos in explosion_locations:
		await get_tree().create_timer(explosion_delay, false).timeout
		
		explosion_delay *= 0.8
		
		var explosion = EXPLOSION.instantiate()
		add_sibling(explosion)
		explosion.position = pos
		explosion.explode(0, 10)
		jiggler.jiggle(1)
	
	await get_tree().create_timer(.5, false).timeout
	var explosion2 = EXPLOSION.instantiate()
	add_sibling(explosion2)
	explosion2.position = beam_start.global_position
	explosion2.explode(0, 20)
	
	pylon_sprite.frame = 1
	beam_start.visible = true
	beam_repeat.visible = true
	beam_start.play()
	beam_repeat.play()
	jiggler.max_skew_jiggle = 0
	jiggler.decay = 0.4
	jiggler.jiggle(1)
	
	repaired.emit()
	
	SoundManager.pylon()
