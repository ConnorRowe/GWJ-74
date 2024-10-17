class_name GemGoblin
extends Baddie

var search_query : PhysicsShapeQueryParameters2D = null
var target_gem : Gem = null
var remaining_tries := 6
var gems_eaten := []
var portal : GoblinPortal = null
var escape := false

func _ready() -> void:
	var gem_search_shape := CircleShape2D.new()
	gem_search_shape.radius = 60
	
	search_query = PhysicsShapeQueryParameters2D.new()
	search_query.collide_with_areas = true
	search_query.collide_with_bodies = false
	search_query.collision_mask = 2
	search_query.shape = gem_search_shape
	
func _physics_process(_delta: float) -> void:
	
	if not escape:	
		if is_instance_valid(target_gem):
			velocity = position.direction_to(target_gem.position) * speed
		
			if position.distance_squared_to(target_gem.position) <= 16:
				# eat gem
				gems_eaten.append(target_gem.xp)
				target_gem.queue_free()
				target_gem = null
				
				look_for_gem.call_deferred()
		else:
			velocity = position.direction_to(portal.position) * speed
	else:
		velocity = position.direction_to(portal.position) * speed		
		if position.distance_squared_to(portal.position) <= 8:
			vanish()
	
	move_and_slide()


func look_for_gem() -> void:
	if is_instance_valid(target_gem):
		return
	
	var space_state = get_world_2d().direct_space_state
	search_query.transform = Transform2D(0, position)
	var collisions = space_state.intersect_shape(search_query, 1)
	if len(collisions) > 0:
		target_gem = collisions[0].collider.owner
		remaining_tries = 6
	else:
		# Disappear after 6 tries
		remaining_tries -= 1
		
		if remaining_tries >= 0:
			escape = true

func die() -> void:
	set_physics_process(false)
	
	for gem_xp in gems_eaten:
		var gem = GEM.instantiate()
		gem.initialise(gem_xp)
		add_sibling(gem)
		gem.position = position
		gem.bounce()
	
	super.die()

func _on_look_for_gem_timer_timeout() -> void:
	look_for_gem()


func vanish() -> void:
	set_physics_process(false)
	
	await get_tree().create_timer(.5, false).timeout
	var tween = create_tween().tween_property(sprite_2d.material, "shader_parameter/fade_amount", 1.0, .5)
	await tween.finished
	portal.disappear()
	dying.emit()
	queue_free()
