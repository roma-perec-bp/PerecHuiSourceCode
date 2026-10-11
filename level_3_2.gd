extends Node3D

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""

var paperIn = false
var canPaper = true
var curPaper = 0

var t = 0.0
var sex = -80
var sex2 = 0
var lerpYe = -80
var lerpYe2 = 0

var noMore = true
var chase = true

var dead = false

var butt1:bool = false
var butt2:bool = false
var butt3:bool = false
var butt4:bool = false
var count:int = 0

var canPause = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainScript.lvl3 = 1
	MainScript.save_data()
	$player.canMove = true
	var tween = get_tree().create_tween()
	tween.tween_property($hud/bg, "self_modulate:a", 0, 3)
	#$track.play()
	await TimerRoot.delay(7)
	_changeTxt("Бля")
	$hud/tasks.text = "Текущее задание:\nНайди Выход"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
		
	if paperIn and Input.is_action_just_pressed("use"):
		if canPaper:
			canPaper = false
			$player.canMove = false
			$hud/paper.visible = true
			$hud/paper2.play()
			$hud/instruct.visible = false
		else:
			canPaper = true
			$player.canMove = true
			$hud/paper.visible = false
			$hud/instruct.visible = true
		
	if butt1:
		if Input.is_action_just_pressed("use"):
			butt1 = false
			$hud/instruct.visible = false
			$butt_sound.play()
			$trigger_0/AnimationPlayer.play('new_animation')
			$trigger_0/activate1.queue_free()
			count += 1
			
			$hud/tasks.text = "Текущее задание:\nАктивируй все рычаги\n"+str(count)+"/4"
			
			if count == 4:
				$hud/tasks.text = "Текущее задание:\nБеги к выходу"
				_changeTxt("Думаю это все рычаги, можно уёбывать отсюда нахуй!")
				$wallGrp/gate.queue_free()
				$pep4.can_move = true
				$pep4.visible = true
			elif count == 1:
				_changeTxt("Окей я что то активировал, возможно этих рычагов еще несколько.\nПопробую найти их всех.")
	if butt2:
		if Input.is_action_just_pressed("use"):
			butt2 = false
			$hud/instruct.visible = false
			$butt_sound.play()
			$trigger_1/AnimationPlayer.play('new_animation')
			$trigger_1/activate2.queue_free()
			count += 1
			
			$hud/tasks.text = "Текущее задание:\nАктивируй все рычаги\n"+str(count)+"/4"
			
			if count == 4:
				$hud/tasks.text = "Текущее задание:\nБеги к выходу"
				_changeTxt("Думаю это все рычаги, можно уёбывать отсюда нахуй!")
				$wallGrp/gate.queue_free()
				$pep4.can_move = true
				$pep4.visible = true
			elif count == 1:
				_changeTxt("Окей я что то активировал, возможно этих рычагов еще несколько.\nПопробую найти их всех.")
	
	if butt3:
		if Input.is_action_just_pressed("use"):
			butt3 = false
			$hud/instruct.visible = false
			$butt_sound.play()
			$trigger_2/AnimationPlayer.play('new_animation')
			$trigger_2/activate3.queue_free()
			count += 1
			
			$hud/tasks.text = "Текущее задание:\nАктивируй все рычаги\n"+str(count)+"/4"
			
			if count == 4:
				$hud/tasks.text = "Текущее задание:\nБеги к выходу"
				_changeTxt("Думаю это все рычаги, можно уёбывать отсюда нахуй!")
				$wallGrp/gate.queue_free()
				$pep4.can_move = true
				$pep4.visible = true
			elif count == 1:
				_changeTxt("Окей я что то активировал, возможно этих рычагов еще несколько.\nПопробую найти их всех.")
	
	if butt4:
		if Input.is_action_just_pressed("use"):
			butt4 = false
			$hud/instruct.visible = false
			$butt_sound.play()
			$trigger_3/AnimationPlayer.play('new_animation')
			$trigger_3/activate4.queue_free()
			count += 1
			
			$hud/tasks.text = "Текущее задание:\nАктивируй все рычаги\n"+str(count)+"/4"
			
			if count == 4:
				$hud/tasks.text = "Текущее задание:\nБеги к выходу"
				_changeTxt("Думаю это все рычаги, можно уёбывать отсюда нахуй!")
				$wallGrp/gate.queue_free()
				$pep4.can_move = true
				$pep4.visible = true
			elif count == 1:
				_changeTxt("Окей я что то активировал, возможно этих рычагов еще несколько.\nПопробую найти их всех.")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not $pep4.isChasing and not $pep5.isChasing and not $pep6.isChasing:
		$chaseTrack.volume_db = -80
		$normalTrack.volume_db = 0
	else:
		$chaseTrack.volume_db = 0
		$normalTrack.volume_db = -80


func _changeTxt(text: String):
	$hud/dialogueBg.visible = true
	$hud/nextDialogue.stop()
	display = ""
	current_char = 0
	cur_lenght = len(text)
	typedTxt = text
	
	$hud/nextCharacter.set_wait_time(0.05)
	$hud/nextCharacter.start()


func _on_next_character_timeout() -> void:
	if current_char < cur_lenght:
		var next_char = typedTxt[current_char]
		display += next_char
		
		$hud/dialogueTxt.text = display
		current_char += 1
		$player/talk.play()
	else:
		$hud/nextCharacter.stop()
		$hud/nextDialogue.one_shot = true
		$hud/nextDialogue.set_wait_time(2)
		$hud/nextDialogue.start()

func _on_next_dialogue_timeout() -> void:
	$hud/dialogueTxt.text = ""
	$hud/dialogueBg.visible = false


func _on_activate_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$activate.queue_free()
		$pep5.can_move = true
		$pep6.can_move = true
		$pepAnnounce.stream = load("res://pep_run.wav");
		$pepAnnounce.play()
		await  TimerRoot.delay(6)
		_changeTxt("Ебанный рот этих лабиринтов, главное быть осторожнее, ведь я явно не один тут...")
	
func jump():
	if not dead:
		canPause = false
		dead = true
		$track.stop()
		$ambience.stop()
		$chaseTrack.stop()
		$normalTrack.stop()
		$jumpscare.visible = true
		if MainScript.lights: $jumpscare/jump.play("jump")
		$jumpscare/scream.play()
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()


func _on_death_1_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		jump()


func _on_exit_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		canPause = false
		$player.canMove = false
		$player.canLook = false
		$exit.queue_free()
		$exit2.play()
		var tween = get_tree().create_tween()
		tween.tween_property($hud/bg, "self_modulate:a", 1, 3)
		var tween2 = get_tree().create_tween()
		tween2.tween_property($ambience, "volume_db", -80, 3)
		var tween3 = get_tree().create_tween()
		tween3.tween_property($track, "volume_db", -80, 3)
		await get_tree().create_timer(6).timeout
		get_tree().change_scene_to_file('res://level3-3.tscn')


func _on_gate_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$gate.queue_free()
		$pep5.can_move = false
		$pep6.can_move = false
		$pep4.can_move = false
		
		$door.play()
		$chaseTrack.stop()
		$normalTrack.stop()
		$wallGrp/gateEnd.visible = true
		$wallGrp/gateEnd/StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
		$pepAnnounce.stream = load("res://pep_good.wav");
		$pepAnnounce.play()


func _on_activate_1_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		butt1 = true
		$hud/instruct.visible = true


func _on_activate_1_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		butt1 = false
		$hud/instruct.visible = false


func _on_activate_2_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		butt2 = true
		$hud/instruct.visible = true


func _on_activate_2_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		butt2 = false
		$hud/instruct.visible = false


func _on_activate_3_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		butt3 = true
		$hud/instruct.visible = true


func _on_activate_3_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		butt3 = false
		$hud/instruct.visible = false


func _on_activate_4_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		butt4 = true
		$hud/instruct.visible = true


func _on_activate_4_body_exited(body: Node3D) -> void:
	if body.name == 'player':
		butt4 = false
		$hud/instruct.visible = false


func _on_hui_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$hui.queue_free()
	
		if count == 0:
			_changeTxt("Ага бля, просто так я отсюда не съебу.\nНадо как-то этот ебучий забор убрать.")


func _on_paper_trigger_1_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true


func _on_paper_trigger_1_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false


func _on_entrance_lock_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$wallGrp/MeshInstance3D51/StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
		$entrance_lock.queue_free()
