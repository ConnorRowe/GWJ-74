class_name ShootingBaddie
extends Baddie

const PROJECTILE = preload("res://Scenes/Projectile.tscn")

const proj_colour_a := Color("#ac3232") 
const proj_colour_b := Color("#fbf236") 

var stats := PlayerStats.new()

func attack() -> void:
	var projectile = PROJECTILE.instantiate()
	projectile.initialise(false, position.direction_to(target.position), stats)
	add_sibling(projectile)
	projectile.position = position
	projectile.lifetime = 2.0
	projectile.set_projectile_colours(proj_colour_a, proj_colour_b)


func _on_attack_timer_timeout() -> void:
	attack()
