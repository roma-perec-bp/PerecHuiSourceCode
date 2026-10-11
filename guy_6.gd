extends CharacterBody3D

@onready var nav: NavigationAgent3D = $nav6
var targetNum:int = 11

func _ready() -> void:
	randomize()
	_change_target()
	
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

func _physics_process(delta: float):
	_walk_test(delta)

func _change_target():
	targetNum = randi_range(0,5)
	#Character that walks can go either to random target for ther OR to player
	nav.target_position = get_parent().get_node("target"+ str(targetNum)).global_position

func _walk_test(elapsed: float):
	var direction = Vector3()
		
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	#It goes to target that is set
	velocity = velocity.lerp(direction * 42, 60 * elapsed)


func _on_nav_6_target_reached() -> void:
	_change_target()


func _on_timer_timeout() -> void:
	_change_target()
