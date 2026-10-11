extends Node3D

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""

var games = false
var died = false
var dead = false

var canPause = true

var trop1=load("res://big_trop.tscn")
var trop2=load("res://small_trop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainScript.lvl3 = 3
	MainScript.save_data()
	follow_fire()
	$player.canMove = true
	$player.gunState = 2
	$perec.play()
	await TimerRoot.delay(2)
	var tween = get_tree().create_tween()
	tween.tween_property($hud/bg, "self_modulate:a", 0, 3)
	var tweengay = get_tree().create_tween()
	tweengay.tween_property($player/hud/ProgressBar2, "value", 5000, 10)
	$hud/tasks.text = "Текущее задание:\nУбей его"
	$player.canShoot = true
	$track.play()
	$iconOfSin/voiceLines.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and canPause:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
		
	if $player.health < 1 and not dead:
		canPause = false
		dead = true
		$player.isDead = true
		$track.stop()
		$player.canShoot = false
		$ambience.stop()
		$jumpscare.visible = true
		if MainScript.lights: $jumpscare/jump.play("jump")
		$jumpscare/scream.play()
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
		
	if $iconOfSin.damageable: $player/hud/ProgressBar2.value = $iconOfSin.health
	
	if games:
		if MainScript.lights:
			$player/Camera3D.h_offset = randf_range(0,0.35)
			$player/Camera3D.v_offset = randf_range(0,0.35)
	else:
		if MainScript.lights:
			$player/Camera3D.h_offset = randf_range(0,0.1)
			$player/Camera3D.v_offset = randf_range(0,0.1)
		
	if died:
		if MainScript.lights:
			$player/Camera3D.h_offset = randf_range(0,1)
			$player/Camera3D.v_offset = randf_range(0,1)
		$player.health = 100


func _on_icon_of_sin_games() -> void:
	$iconOfSin/voiceLines.stream = load("res://uhOh.wav")
	$iconOfSin/voiceLines.play()
	$fire.visible = true
	games = true
	$boom.play(0)
	await TimerRoot.delay(0.05)
	$fire2.visible = true
	$boom.play(0)
	await TimerRoot.delay(0.05)
	$fire3.visible = true
	$boom.play(0)
	await TimerRoot.delay(0.05)
	$fire4.visible = true
	$boom.play(0)
	await TimerRoot.delay(0.05)
	$fire5.visible = true
	$boom.play(0)
	await TimerRoot.delay(0.05)
	$fire6.visible = true
	$boom.play(0)
	await TimerRoot.delay(0.05)
	$fire7.visible = true
	$boom.play(0)
	await TimerRoot.delay(0.05)
	$fire8.visible = true
	$boom.play(0)
	await TimerRoot.delay(0.05)
	$fire9.visible = true
	$boom.play(0)
	await TimerRoot.delay(0.05)


func _on_icon_of_sin_death() -> void:
	canPause = false
	$player.win = true
	$fire_follow.visible = false
	$iconOfSin/voiceLines.stream = load("res://sin_death.wav")
	$iconOfSin/voiceLines.play()
	if MainScript.progress == 2:
		MainScript.progress = 3
		MainScript.lvl3 = 0
		MainScript.save_data()
	else:
		MainScript.lvl3 = 0
		MainScript.save_data()
	$track.stop()
	died = true
	$player/hud.visible = false
	$player/hud/gun.play("default")
	$player.canShoot = false
	$player/shot.volume_db = -80
	var tween = get_tree().create_tween()
	tween.tween_property($ending/white, "self_modulate:a", 1, 6)
	await get_tree().create_timer(6).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property($ending/black, "self_modulate:a", 1, 3)
	await get_tree().create_timer(6).timeout
	$ending/AudioStreamPlayer.play()
	await get_tree().create_timer(30).timeout
	$ambience.stop()
	$ending/line2.play()
	await get_tree().create_timer(0.6).timeout
	$ending/line.self_modulate.a = 0.2
	await get_tree().create_timer(0.6).timeout
	$ending/line.self_modulate.a = 0.4
	await get_tree().create_timer(0.6).timeout
	$ending/line.self_modulate.a = 0.6
	await get_tree().create_timer(0.6).timeout
	$ending/line.self_modulate.a = 0.8
	await get_tree().create_timer(0.6).timeout
	$ending/line.self_modulate.a = 1
	await get_tree().create_timer(6).timeout
	get_tree().change_scene_to_file('res://mainMenu.tscn')


func _on_spawn_timer_timeout() -> void:
	var instRight = trop2.instantiate()
	instRight.position = $spawnPoint1.global_position
	instRight.transform.basis = $spawnPoint1.global_transform.basis
	add_child(instRight)


func _on_icon_of_sin_spawn() -> void:
	var instRight
	var instLeft
	if randi_range(0,1) == 1:
		instRight = trop1.instantiate()
	else:
		instRight = trop2.instantiate()
		
	if randi_range(0,1) == 1:
		instLeft = trop1.instantiate()
	else:
		instLeft = trop2.instantiate()
		
	instRight.position = $spawnPoint1.global_position
	instRight.transform.basis = $spawnPoint1.global_transform.basis
	add_child(instRight)
	
	$spawnPoint1/AnimatedSprite3D.play("default")
	
	instLeft.position = $spawnPoint2.global_position
	instLeft.transform.basis = $spawnPoint2.global_transform.basis
	add_child(instLeft)

	$spawnPoint2/AnimatedSprite3D2.play("default")
	
	if games:
		var instRight2
		var instLeft2
		if randi_range(0,1) == 1:
			instRight2 = trop1.instantiate()
		else:
			instRight2 = trop2.instantiate()
		
		if randi_range(0,1) == 1:
			instLeft2 = trop1.instantiate()
		else:
			instLeft2 = trop2.instantiate()
		
		instRight2.position = $spawnPoint3.global_position
		instRight2.transform.basis = $spawnPoint3.global_transform.basis
		add_child(instRight2)
	
		$spawnPoint3/AnimatedSprite3D.play("default")
	
		instLeft2.position = $spawnPoint4.global_position
		instLeft2.transform.basis = $spawnPoint4.global_transform.basis
		add_child(instLeft2)

		$spawnPoint4/AnimatedSprite3D2.play("default")


func _on_icon_of_sin_shield_signal() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($iconOfSin/shield, "position:y", -0.195, 2)
	if games:
		await TimerRoot.delay(8)
		var tweenEnd = get_tree().create_tween()
		tweenEnd.tween_property($iconOfSin/shield, "position:y", -2.595, 5)
		$iconOfSin/shield_bye.play()
		await TimerRoot.delay(4)
		$iconOfSin.shield = false
	else:
		await TimerRoot.delay(5)
		var tweenEnd = get_tree().create_tween()
		tweenEnd.tween_property($iconOfSin/shield, "position:y", -2.595, 2)
		$iconOfSin/shield_bye.play()
		await TimerRoot.delay(3)
		$iconOfSin.shield = false

func follow_fire():
	if died: return
	$fire_follow.set_position($player/fire_spawn.global_position)
	$fire_follow.position.y = 1.978
	var tweenFire = get_tree().create_tween()
	tweenFire.tween_property($fire_follow, "position:y", 0.978, 0.1)
	await TimerRoot.delay(0.1)
	if died: return
	follow_fire()


func _on_icon_of_sin_fire() -> void:
	$fire_follow.visible = true
	await TimerRoot.delay(3)
	$iconOfSin.fire_distract = false
	$fire_follow.visible = false

func _changeTxt(text: String):
	$hud/dialogueBg.visible = true
	$hud/nextDialogue.stop()
	display = ""
	current_char = 0
	cur_lenght = len(text)
	typedTxt = text
	
	$hud/nextCharacter.set_wait_time(0.05)
	$hud/nextCharacter.start()


func _on_next_dialogue_timeout() -> void:
	$hud/dialogueTxt.text = ""
	$hud/dialogueBg.visible = false


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


func _on_icon_of_sin_finale() -> void:
	_changeTxt("БЛЯТЬ! Патроны кончились((((\nОсталась лишь эта пукалка ебанная...")
	$player.gunState = 1
	$player/hud/trans.play("new_animation")
