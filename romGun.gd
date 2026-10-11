extends CharacterBody3D
var canMove = true
var canLook = true
var canShoot = false
var isDead = false
var win = false

var SPEED = 6

var health:float = 100

var mouse_relative_x = 0
var mouse_relative_y = 0

@onready var heal = $heal

var bigHurt = 0
var smallHurt = 0
var zombHurt = 0

var flashTween: Tween = null
var hitTween: Tween = null

var gunState:int = 0

var hitters:float = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hurtManager()

func _physics_process(_delta: float) -> void:
	#if Input.is_action_pressed("run"):
		#SPEED = 6
	#else:
		#SPEED = 4
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if canMove:
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		move_and_slide()
		

func _process(delta: float) -> void:
	if health > 100:
		health = 100
		
	$hud/Label.text = "+"+str(int(health))

func _input(event) -> void:
	if event is InputEventMouseMotion:
		if !canLook: return
		rotation.y -= event.relative.x / MainScript.mouseSense
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 50)
		
	if canShoot:
		if Input.is_action_just_pressed("shoot"):
			if gunState == 1:
				$hud/gun.play("shoot")
				canShoot = false
				$shot.play(0)
				shoot()
			elif gunState == 2:
				$hud/shootgun.play("shot")
				canShoot = false
				$shot2.play(0)
				shootShotgun()

func shoot() -> void:
	var enemy: Array[Area3D] = $shootHit.get_overlapping_areas()
	enemy.sort_custom(func(a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
	for target: Area3D in enemy:
		if target.get_parent().deadBool: return
		var res = rayCheck(target.global_position)
		if (res.collider == target): 
			target.get_parent().hit()

func shootShotgun() -> void:
	var enemy: Array[Area3D] = $shootHit2.get_overlapping_areas()
	enemy.sort_custom(func(a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
	for target: Area3D in enemy:
		if target.get_parent().deadBool: return
		var res = rayCheck(target.global_position)
		if (res.collider == target): 
			target.get_parent().shothit()

func rayCheck(pos: Vector3) -> Dictionary:
	var space = get_world_3d().direct_space_state
	
	var og = global_position
	var end = pos
	var que = PhysicsRayQueryParameters3D.create(og, end)
	que.collide_with_areas = true
	
	var result = space.intersect_ray(que)
	return result


func _on_gun_animation_finished() -> void:
	$hud/gun.play("default")
	canShoot = true


func _on_hit_body_entered(body: Node3D) -> void:
	if "bigTrop" in body.name:
		if body.deadBool == true: return
		bigHurt += 1
		
	if "smallTrop" in body.name:
		if body.deadBool == true: return
		smallHurt += 1
		
	if "zomb" in body.name:
		if body.deadBool == true: return
		zombHurt += 1


func _on_hit_body_exited(body: Node3D) -> void:
	if "bigTrop" in body.name:
		bigHurt -= 1
		
	if "smallTrop" in body.name:
		smallHurt -= 1
		
	if "zomb" in body.name:
		zombHurt -= 1


func _on_shootgun_animation_finished() -> void:
	$hud/shootgun.play("default")
	canShoot = true
	
func hurtPain(value:float):
	if isDead: return
	if win: return
	health -= value
	$pain.play()
	$hit3.play()
	_flash_camera(0.2 + hitters, 1 + hitters)
	hitters += 0.1

func hurtManager():
	if isDead: return
	if win: return
	
	if smallHurt != 0:
		health -= 6 * smallHurt
		$pain.play()
		$hit2.play()
		$hud/blood.self_modulate.a += 0.1
		
	if bigHurt != 0:
		health -= 12 * bigHurt
		$pain.play()
		$hit2.play()
		$hud/blood.self_modulate.a += 0.3
		
	if zombHurt != 0:
		health -= 24 * zombHurt
		$pain.play()
		$hit2.play()
		$hud/blood.self_modulate.a += 0.6
	
	var tween = get_tree().create_tween()
	tween.tween_property($hud/blood, "self_modulate:a", 0, 1)
	await TimerRoot.delay(1)
	hurtManager()

func _flash_camera(a:float, t:float):
	if flashTween and flashTween.is_running():
		flashTween.kill()
		
	flashTween = get_tree().create_tween()
		
	$hud/blood2.self_modulate.a = a
	flashTween.tween_property($hud/blood2, "self_modulate:a", 0, t)
	
	if hitTween and hitTween.is_running():
		hitTween.kill()
		
	hitTween = get_tree().create_tween()
	
	hitTween.tween_property(self, "hitters", 0, t)
