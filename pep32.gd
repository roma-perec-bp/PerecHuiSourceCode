extends CharacterBody3D

const SPEED = 5
var can_move = false

@onready var nav: NavigationAgent3D = $NavigationAgent3D

@onready var blindChase = 5
var isChasing:bool = false

func _ready():
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
	
	#It rotates on where it looks
	rotation.y = atan2(velocity.x,velocity.z)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if can_move:
		_walk_test(delta)
		#$RayCast3D.look_at(get_parent().get_node("player").position)
		nav.target_position = get_parent().get_node("player").global_position
	else:
		velocity = Vector3(0,0,0)
		
	if $RayCast3D.is_colliding():
		if $RayCast3D.get_collider() == get_parent().get_node("player"):
			isChasing = true
			blindChase = 5
		elif blindChase <= 0:
			isChasing = false
				
	if blindChase >= 0:
		blindChase-=delta
		
	move_and_slide()

func _walk_test(elapsed: float):
	var direction = Vector3()
		
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	#It goes to target that is set
	velocity = direction * SPEED
