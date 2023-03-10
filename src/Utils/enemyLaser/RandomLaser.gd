extends RayCast2D

var damage: float = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var intervalTime =3
var shootTime=0.7
var is_casting := false setget set_is_casting
var isShot= false 
var is_enabled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	$Line2D.points[1] = $Line2D.points[0]
	if get_parent().enable_shooting : $ShootTimer.start(intervalTime)
	

func set_facing(facing):
	if facing == "left": 
		cast_to.x = -30000
		$CastingParticle.process_material.direction.x=-1
		$collisionParticle.process_material.direction.x=-1
	else: 
		cast_to.x = 30000
		$CastingParticle.process_material.direction.x=1
		$collisionParticle.process_material.direction.x=1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collider = get_collider()
		
	if is_casting and collider is CollisionObject2D:
		if collider.collision_layer == 1:
			collider.decrease_health(damage * delta)
			pass
	
	if isShot==true and is_casting==false and get_parent().get_parent().is_processing():
		self.is_casting = true
		$laserStart.play()
		$soundTimer.start(0.4)
		$Timer.start(shootTime)
	
	

#$beamParticle.process_material.emission_box_extents.x=castPoint.length()*0.5
	

#func _unhandled_input(event: InputEvent)->void:
#	if event is InputEventMouseButton:
#		self.is_casting = not is_casting

#func _unhandled_key_input(event):
	#if event is InputEventKey:
		#self.set_is_casting(event.pressed)
	
func _physics_process(delta):
	
#	if Input.is_mouse_button_pressed(1):
#		self.is_casting = not is_casting
	
	var cast_point = cast_to
#	print(cast_point)
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
	#if $laserContinue.playing:
		#$laserContinue.stop()
	if $laserStart.playing:
		$laserStart.stop()
	self.isShot=false


func _on_ShootTimer_timeout():
	self.isShot=true
	$ShootTimer.start(intervalTime)
	


func _on_soundTimer_timeout():
	$laserStart.stop()
	#$laserContinue.play()
