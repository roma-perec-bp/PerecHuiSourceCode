extends CharacterBody3D

const SPEED = 2
var saw = false
var can_move = true
var deadBool = false
var canKill = true

var health = 50

var effect=load("res://effect.tscn")

@onready var nav: NavigationAgent3D = $NavigationAgent3D

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
		$RayCast3D.look_at(get_parent().get_node("player").global_position)
	else:
		velocity = Vector3(0,0,0)
	if not saw:
		if $RayCast3D.is_colliding():
			if $RayCast3D.get_collider() == get_parent().get_node("player"):
				$AudioStreamPlayer.stream = load("res://smallSaw.wav")
				$AudioStreamPlayer.play(0)
				saw = true
	
	if saw:
		nav.target_position = get_parent().get_node("player").global_position
		
	move_and_slide()

func _walk_test(elapsed: float):
	var direction = Vector3()
		
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	#It goes to target that is set
	velocity = direction * SPEED

func hit():
	health -= 25
	
	if health < 1:
		dead()
	else:
		hurt()
		
func shothit():
	health -= 125
	
	if health < 1:
		dead()
	else:
		hurt()
	
func hurt():
	$AudioStreamPlayer.stream = load("res://smallPain.wav")
	$AudioStreamPlayer.play(0)
	$Sprite3D.modulate = Color(0.6, 0.6, 0.6)
	await TimerRoot.delay(0.3)
	$Sprite3D.modulate = Color(1, 1, 1)
	
func dead():
	if not deadBool:
		if get_parent().get_node("player").health < 100 and randi_range(0,4) == 4:
			get_parent().get_node("player").health += 5
			get_parent().get_node("player").heal.play(0)
			
		var inst = effect.instantiate()
		inst.position = self.global_position
		inst.transform.basis = self.global_transform.basis
		get_parent().add_child(inst)
		
		$AudioStreamPlayer.stream = load("res://smallDeath.wav")
		$AudioStreamPlayer.play(0)
		deadBool = true
		can_move = false
		canKill = false
		$Sprite3D.visible = false
		$CollisionShape3D.queue_free()
		await TimerRoot.delay(0.1)
		$hit/CollisionShape3D.disabled = true
		await TimerRoot.delay(1)
		queue_free()
