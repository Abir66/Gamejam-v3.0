extends RayCast2D

var damage: float = 2
var is_casting := false setget set_is_casting
var isShot= false
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	$Line2D.points[1] = $Line2D.points[0]

func shoot_laser(facing):
	if facing == "left" : 
		cast_to.x = -3000
		$CastingParticle.process_material.direction.x=-1
	else : 
		cast_to.x = 3000
		$CastingParticle.process_material.direction.x=1

	self.is_casting = true
	$laserStartAudio.play()
	
	$startAudioTimer.start(0.3)
	

func stop_laser():
	self.is_casting = false
	$laserContinueAudio.stop()
	if $laserStartAudio.playing:
		$laserStartAudio.stop()
		

func change_facing(facing):
	if facing == "left" : cast_to.x = -3000
	else : cast_to.x = 3000
		
	
func _physics_process(delta):
	
#	if Input.is_mouse_button_pressed(1):
#		self.is_casting = not is_casting
	
	var cast_point = cast_to
	# print(cast_point)
	force_raycast_update()
	$collisionParticle.emitting=is_colliding()
	
	if is_colliding():
#		print(get_collision_point())
		cast_point = to_local(get_collision_point())
		$collisionParticle.global_rotation=get_collision_normal().angle()
		$collisionParticle.position = cast_point
	$Line2D.points[1]=cast_point
	$beamParticle.position=cast_point*0.5
	$beamParticle.process_material.emission_box_extents.x=cast_point.length()*0.5
#	print($collisionParticle.position)
		
	
	
func set_is_casting(cast: bool)->void:
	is_casting= cast
	$beamParticle.emitting=is_casting
	$CastingParticle.emitting=is_casting
	if is_casting: 
		appear()
	else:
		$collisionParticle.emitting=false
		disappear()
		
	set_physics_process(is_casting)
	

func _process(delta):
	var collider = get_collider()
	
	if is_casting and collider is CollisionObject2D:
		if collider.collision_layer == 2:
			collider.health -= damage


func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"width",0,7.0,0.2)
	$Tween.start()
	
	
func disappear()->void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"width",7.0,0,0.2)
	$Tween.start()
	


func _on_Timer_timeout():
	self.set_is_casting(false)


func _on_startAudioTimer_timeout():
	if $laserStartAudio.playing:
		$laserContinueAudio.play()
	$laserStartAudio.stop()
	
	
