class_name Jiggler
extends Node

@export var scale_jiggle := Vector2.ZERO
@export var max_skew_jiggle := 0.0
@export var max_rotation_jiggle := 0.0
@export var decay: float = .9
@export var noise: Noise = preload("res://Assets/new_fast_noise_lite.tres")
var trauma: float = 0
var noise_y: int = 0
var parent: Node2D

func _ready() -> void:
	parent = get_parent()

func _process(delta) -> void:
	if trauma > 0:
		trauma = maxf(trauma - (decay * delta), 0)
		
		var amount: float = pow(trauma, 2)
		
		if noise_y > 1000000:
			noise_y = 0
		else:
			noise_y += 1
		
		# Jiggle skew
		var skew_jiggle = max_skew_jiggle * amount * ((noise.get_noise_2d(noise.seed, noise_y) * 2) - 1)
		parent.skew = skew_jiggle
		
		# Jiggle rotation
		var rotation_jiggle = max_rotation_jiggle * amount * ((noise.get_noise_2d(noise.seed, noise_y) * 2) - 1)
		parent.rotation_degrees = rotation_jiggle
		
		# Jiggle scale
		var scale = Vector2()
		scale.x = scale_jiggle.x * amount * noise.get_noise_2d(noise.seed * 4, noise_y)
		scale.y = scale_jiggle.y * amount * noise.get_noise_2d(noise.seed * 5, noise_y)		
		parent.scale = Vector2.ONE + scale

func jiggle(strength: float) -> void:
	trauma = minf(trauma + strength, 1)
