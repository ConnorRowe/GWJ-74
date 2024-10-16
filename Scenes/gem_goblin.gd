class_name GemGoblin
extends Baddie

var search_query : PhysicsShapeQueryParameters2D = null
var target_gem : Gem = null
var remaining_tries := 6

func _ready() -> void:
	var gem_search_shape := CircleShape2D.new()
	gem_search_shape.radius = 60
	
	search_query = PhysicsShapeQueryParameters2D.new()
	search_query.collide_with_areas = true
	search_query.collide_with_bodies = false
	search_query.collision_mask = 2
	search_query.shape = gem_search_shape
	
func _physics_process(_delta: float) -> void:
	if is_instance_valid(target_gem):
		velocity = position.direction_to(target_gem.position) * speed
	
		if position.distance_squared_to(target_gem.position) <= 16:
			# eat gem
			xp += target_gem.xp
			target_gem.queue_free()
			target_gem = null
			
			look_for_gem.call_deferred()
	
	move_and_slide()


func look_for_gem() -> void:
	if is_instance_valid(target_gem):
		return
	
	var space_state = get_world_2d().direct_space_state
	search_query.transform = Transform2D(0, position)
	var collisions = space_state.intersect_shape(search_query, 1)
	if len(collisions) > 0:
		target_gem = collisions[0].collider.owner
	else:
		# Disappear after 6 tries
		remaining_tries -= 1
		
		if remaining_tries >= 0:
			vanish()


func _on_look_for_gem_timer_timeout() -> void:
	look_for_gem()

func vanish() -> void:
	dying.emit()
	queue_free()
