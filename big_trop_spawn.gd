extends CharacterBody3D

const SPEED = 4
var can_move = true
var deadBool = false
var canKill = true
var saw = false

var effect=load("res://effect.tscn")

var health = 50

@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _ready():
	$AudioStreamPlayer.stream = load("res://bigSaw.wav")
	$AudioStreamPlayer.play(0)
	
func _process(delta: float) -> void:
	
	#It rotates on where it looks
	rotation.y = atan2(velocity.x,velocity.z)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	velocity = Vector3.ZERO
	nav.set_target_position(get_parent().get_node("player").global_position)
	
	var next_path = nav.get_next_path_position()
	velocity = (next_path - global_position).normalized() * SPEED
		
	move_and_slide()

func hit():
	health -= 25
	
	if health < 1:
		dead()
	else:
		hurt()
		
func shothit():
	health -= 50
	
	if health < 1:
		dead()
	else:
		hurt()
	
func hurt():
	$AudioStreamPlayer.stream = load("res://bigPain.wav")
	$AudioStreamPlayer.play(0)
	$Sprite3D.modulate = Color(0.6, 0.6, 0.6)
	await TimerRoot.delay(0.3)
	$Sprite3D.modulate = Color(1, 1, 1)
	
func dead():
	if not deadBool:
		if get_parent().get_node("player").health < 100 and randi_range(0,4) == 4:
			get_parent().get_node("player").health += 10
			$heal.play()
			
		var inst = effect.instantiate()
		inst.position = $Sprite3D.global_position
		get_parent().add_child(inst)
		
		$AudioStreamPlayer.stream = load("res://bigDeath.wav")
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
