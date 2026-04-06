extends Entity
class_name Enemy

var ai:BaseAI


func _ready() -> void:
	super._ready()
	entity_type="enemy"
	ai=BaseAI.new()
	ai.body=self
	ai.init_ai()

func rotate_to_target(delta:float):
	var dir=global_position.direction_to(ai.target)
	#print("DEBUG: dir",dir)
	var angle=-atan2(dir.z,dir.x)-PI/2.0
	rotation.y=lerp_angle(rotation.y,angle,rotation_speed*delta)
	
func _physics_process(delta: float) -> void:
	ai.update(delta)
	super._physics_process(delta)
	if is_knockingback:
		return
	
	if ai.is_move_to_target:
		if global_position.distance_to(ai.target)<ai.minimal_distance:
			ai.is_target_reached=true
		else:	
			rotate_to_target(delta)
			#print("DEBUG: angle ",180.0*angle/PI)
			velocity.x=-basis.z.x*speed
			velocity.z=-basis.z.z*speed
	
	if weapon:
		if weapon.is_active():
			rotate_to_target(delta)
	velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
	move_and_slide()
