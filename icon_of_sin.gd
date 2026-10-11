extends Sprite3D

signal games
signal death

signal spawn
signal shield_signal
signal fire

signal finale

var can_move = true
var deadBool = false
var canKill = true
var saw = false
var damageable = false
var shield:bool = false
var fire_distract:bool = false

var phase = 0
var health = 5000
var thinker = 6
var att = -1
var gamesAreOver = false

var projects = false
var enemies = false
var chaos = false

var trop=load("res://bullet_1.tscn")
var trop2=load("res://bullet_2.tscn")
var trop3=load("res://bullet_3.tscn")

var plasm=load("res://plasma.tscn")

var rain=load("res://rainAttack.tscn")

var stalker=load("res://flying_obj.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	await TimerRoot.delay(13)
	damageable = true
	attack()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$shoot.look_at(get_parent().get_node("player").global_position)
	
func hit():
	if !damageable: return
	health -= 25
	
	if health < 0:
		dead()
	else:
		hurt()
		
func shothit():
	if !damageable: return
	health -= 75
	
	if health < 0:
		dead()
	else:
		hurt()

func hurt():
	if !damageable: return
	modulate = Color(0.6, 0.6, 0.6)
	await TimerRoot.delay(0.3)
	modulate = Color(1, 1, 1)
	
func dead():
	if not deadBool:
		deadBool = true
		$Timer.stop()
		emit_signal("death")


func _on_progress_bar_2_value_changed(value: float) -> void:
	if !damageable: return
	if value < 1000 and not chaos:
		chaos = true
		thinker = 3
		phase = 4
		$pain.play(0)
		emit_signal("finale")
		
	if value < 2500 and not gamesAreOver:
		gamesAreOver = true
		thinker = 4
		$pain.play(0)
		phase = 3
		emit_signal("games")
		
	if value < 3000 and not enemies:
		enemies = true
		thinker = 5
		$pain.play(0)
		phase = 2
		
	if value < 4000 and not projects:
		projects = true
		thinker = 5.5
		$pain.play(0)
		phase = 1

func attack():
	var prevAtt:int
	prevAtt = att
	match (phase):
		0:
			att = randi_range(0,1)
		1:
			att = randi_range(0,2)
		2:
			att = randi_range(0,3)
		3:
			att = randi_range(0,5)
		4:
			att = randi_range(0,6)
		
	if prevAtt == att:
		attack()
		return
		
	if shield and att == 3:
		attack()
		return
		
	if fire_distract and att == 6:
		attack()
		return
		
	$Timer.one_shot = true
	$Timer.set_wait_time(thinker)
	$Timer.start()
		
	match att:
		0:
			$attack.play(0)
			if gamesAreOver:
				for i in 6:
					await TimerRoot.delay(0.25)
					$troopAtt.play(0)
					var inst = trop.instantiate()
					inst.position = $shoot.global_position
					inst.transform.basis = $shoot.global_transform.basis
					get_parent().add_child(inst)
					
					var instLeft = trop2.instantiate()
					instLeft.position = $shoot.global_position
					instLeft.transform.basis = $shoot.global_transform.basis
					get_parent().add_child(instLeft)
					
					var instRight = trop3.instantiate()
					instRight.position = $shoot.global_position
					instRight.transform.basis = $shoot.global_transform.basis
					get_parent().add_child(instRight)
			else:
				for i in 3:
					await TimerRoot.delay(0.5)
					$troopAtt.play(0)
					var inst = trop.instantiate()
					inst.position = $shoot.global_position
					inst.transform.basis = $shoot.global_transform.basis
					get_parent().add_child(inst)
					
					var instLeft = trop2.instantiate()
					instLeft.position = $shoot.global_position
					instLeft.transform.basis = $shoot.global_transform.basis
					get_parent().add_child(instLeft)
					
					var instRight = trop3.instantiate()
					instRight.position = $shoot.global_position
					instRight.transform.basis = $shoot.global_transform.basis
					get_parent().add_child(instRight)
		1:
			$attack.play(0)
			if gamesAreOver:
				for i in 42:
					await TimerRoot.delay(0.015)
					var randomPos = Vector3(randf_range(-16, 12), 0.25, randf_range(-15, 14))
					$bomAtt.play(0)
					var bmom = rain.instantiate()
					bmom.name = "rainAttak"+str(i)
					bmom.position = randomPos
					get_parent().add_child(bmom)
			else:
				for i in 16:
					await TimerRoot.delay(0.1)
					var randomPos = Vector3(randf_range(-16, 12), 0.25, randf_range(-15, 14))
					$bomAtt.play(0)
					var bmom = rain.instantiate()
					bmom.name = "rainAttak"+str(i)
					bmom.position = randomPos
					get_parent().add_child(bmom)
		2:
			$spawnAtt.play(0)
			await TimerRoot.delay(2)
			$teleport.play()
			emit_signal("spawn")
		3:
			shield = true
			$shield2.play(0)
			emit_signal("shield_signal")
		4:
			$attack.play(0)
			for i in 15:
				await TimerRoot.delay(0.1)
				$plasAtt.play(0)
				var plama = plasm.instantiate()
				plama.position = $shoot.global_position
				plama.transform.basis = $shoot.global_transform.basis
				get_parent().add_child(plama)
			
		5:
			$attack.play(0)
			$followAtt.play()
			var fol = stalker.instantiate()
			fol.position = $shoot.global_position
			fol.transform.basis = $shoot.global_transform.basis
			get_parent().add_child(fol)
			
		6:
			fire_distract = true
			emit_signal("fire")
			$attack.play(0)
			$fire.play(0)

func _on_timer_timeout() -> void:
	attack()
