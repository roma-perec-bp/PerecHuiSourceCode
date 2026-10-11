extends CharacterBody3D

const SPEED = 4.8
var can_move = false
var curAnim:String = "idle"

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

#rotation variables
var cam
var cam_pos
var look_point_pos
var look_point_dir
var cam_dir
var angle_to_cam
var angle_to_lookpoint
var enemy_angle

func _ready():
	#Get the player's camera
	cam = get_viewport().get_camera_3d();
	
	#warning fix for NavAgent
	set_physics_process(false)
	call_deferred("actor_setup")
	
#check setup
func actor_setup():
	NavigationServer3D.map_changed.connect(Callable(map_ready))
	
#check if ready
func map_ready(_rid): 
	set_physics_process(true)
	NavigationServer3D.map_changed.disconnect(Callable(map_ready))
	
func _process(delta: float) -> void:
	#rotation system
	rotation_handle()
	
	#It rotates on where it looks
	rotation.y = atan2(velocity.x,velocity.z)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if can_move:
		curAnim = "walk"
		_walk_test(delta)
	else:
		curAnim = "idle"
		velocity = Vector3(0,0,0)

	move_and_slide()
	
func rotation_handle():
	cam_pos = cam.global_transform.origin
	
	#Gets the position of the object the sprite is "looking" at
	look_point_pos = get_parent().get_node("zomb/LookpointPlace").global_position
	look_point_dir = position - look_point_pos
	
	# Calculate the angle of the sprite, taking into consideration both the object the sprite is looking at
	# and the position of the camera, and convert the radians to degrees for more human friendly readability
	cam_dir = position - cam_pos
	angle_to_cam = rad_to_deg(atan2(cam_dir.x, cam_dir.z))
	angle_to_lookpoint = rad_to_deg(atan2(look_point_dir.x, look_point_dir.z))
	enemy_angle = angle_to_cam - angle_to_lookpoint
	
	#Fix negative degrees
	if enemy_angle < 0:
		enemy_angle += 360
		
	#Here I split up the angle in nice equal chunks so we get 8 even segments for an
	# 8-directional sprite, like most classic FPS games!
	# Feel free to multiply/divide the statements if
	# you want something like only 4-directions or even 16 or more, the limit is your
	# imagination/hardware!
	
	if enemy_angle >= 292.5 && enemy_angle < 337.5:
		sprite.play(curAnim+"-front_right")

	elif enemy_angle >= 22.5 && enemy_angle < 67.5:
		sprite.play(curAnim+"-front_left")

	elif enemy_angle >= 67.5 && enemy_angle < 112.5:
		sprite.play(curAnim+"-left")

	elif enemy_angle >= 112.5 && enemy_angle < 157.5:
		sprite.play(curAnim+"-back_left")

	elif enemy_angle >= 157.5 && enemy_angle < 202.5:
		sprite.play(curAnim+"-back")

	elif enemy_angle >= 202.5 && enemy_angle < 247.5:
		sprite.play(curAnim+"-back_right")

	elif enemy_angle >= 247.5 && enemy_angle < 292.5:
		sprite.play(curAnim+"-right")
	
	elif enemy_angle >= 337.5 || enemy_angle > 22.5:
		sprite.play(curAnim+"-front")

func _walk_test(elapsed: float):
	var direction = Vector3()
	
	nav.target_position = get_parent().get_node("player").global_position
		
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	#It goes to target that is set
	velocity = direction * SPEED
