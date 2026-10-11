extends Node3D

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""

var dead = false

var canPause = true

var paperIn = false
var canPaper = true
var curPaper = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainScript.lvl3 = 2
	MainScript.save_data()
	$player.canMove = true
	var tween = get_tree().create_tween()
	tween.tween_property($hud/bg, "self_modulate:a", 0, 3)
	_changeTxt("Мне нужно что то для защиты, это уже пиздец какой-то...")
	$hud/tasks.text = "Текущее задание:\nНайди оружие для защиты"


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
			$hud/instruct2.visible = false
		else:
			canPaper = true
			$player.canMove = true
			$hud/paper.visible = false
			$hud/instruct2.visible = true
		
	if $player.health < 1 and not dead:
		$player.isDead = true
		canPause = false
		dead = true
		$track.stop()
		$player.canShoot = false
		$ambience.stop()
		$jumpscare.visible = true
		if MainScript.lights: $jumpscare/jump.play("jump")
		$jumpscare/scream.play()
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
	
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


func _on_gun_trigger_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		var tweengun = get_tree().create_tween()
		tweengun.tween_property($player/hud/Label2, "self_modulate:a", 0, 3)
		$cock.play()
		$player.canShoot = true
		$player.gunState = 1
		$player/hud.visible = true
		$gun.visible = false
		$gunTrigger.queue_free()
		var tween = get_tree().create_tween()
		tween.tween_property($track, "volume_db", -6, 3)
		$track.play()
		_changeTxt("Это поможет.")
		$hud/tasks.text = "Текущее задание:\nУБИВАЙ"
		await TimerRoot.delay(2)
		_changeTxt("ПОГНАЛИ!")
		await TimerRoot.delay(6)
		$pep_gun.play()


func _on_ann_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$ann.queue_free()
		$pep_ann.play()


func _on_exit_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		canPause = false
		$exit.queue_free()
		$track.stop()
		$player.canShoot = false
		$ambience.stop()
		$hud/bg.self_modulate.a = 1
		$teleport.play()
		$player.health = 9999 #so he wont die
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file('res://level3-4.tscn')


func _on_shotgun_trigger_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$cock.play(0)
		$player.gunState = 2
		$player/hud/shootgun.visible = true
		$player/hud/gun.visible = false
		$shotgun.visible = false
		$shotgunTrigger.queue_free()
		_changeTxt("Опа!")
		await TimerRoot.delay(2)
		$pep_shotgun.play()


func _on_zomb_death() -> void:
	var tweenFunny = create_tween()	
	tweenFunny.tween_property($NavigationRegion3D/wallGrp/gate, "position:y", -180, 6)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$Area3D.queue_free()
		$pep_over.play()


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$Area3D2.queue_free()
		$pep_end.play()
		$player.set_position($target.global_position)
		$player.global_rotation.y = 180
		$player/Camera3D/MeshInstance3D.visible = false
		$teleport.play()
		await TimerRoot.delay(4)
		var tweenFunny = create_tween()	
		tweenFunny.tween_property($NavigationRegion3D/wallGrp/MeshInstance3D209, "position:y", -180, 2)
		$crack.play()


func _on_area_3d_3_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$Area3D3.queue_free()
		var tween = get_tree().create_tween()
		tween.tween_property($track, "volume_db", -80.0, 3)


func _on_paper_trigger_1_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct2.visible = true
		paperIn = true


func _on_paper_trigger_1_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct2.visible = false
		paperIn = false
