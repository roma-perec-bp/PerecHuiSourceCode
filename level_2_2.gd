extends Node3D

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""

var door = 0
var opened = false

var cult = false
var t = 0.0
var sex = 0.26
var lerpYe = 0.26

var noMore = true
var canPause = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainScript.lvl2 = 1
	MainScript.save_data()
	$chaseTrack.pitch_scale = 0.26
	$player.canMove = false
	var tween = get_tree().create_tween()
	tween.tween_property($hud/bg, "self_modulate:a", 0, 6)
	#$track.play()
	_changeTxt("Фух... Это было близко, думаю оно отстало...")
	$hud/tasks.text = "Текущее задание:\n..."
	await TimerRoot.delay(4)
	$player.canMove = true
	_changeTxt("Но... А где я теперь?")

func _physics_process(delta: float) -> void:
	if cult and MainScript.lights:
		$End/text.position.x = randf_range(0,640)
		$End/text.position.y = randf_range(0,480)
		
		$End/text2.position.x = randf_range(0,640)
		$End/text2.position.y = randf_range(0,480)
		
		$End/text3.position.x = randf_range(0,640)
		$End/text3.position.y = randf_range(0,480)
		
		$player/Camera3D.h_offset = randf_range(0,0.5)
		$player/Camera3D.v_offset = randf_range(0,0.5)

	if Input.is_action_just_pressed("escape") and canPause:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
		
	if noMore:
		if $zomb.isChasing:
			$chaseTrack.pitch_scale = 1
		else:
			$chaseTrack.pitch_scale = 0.26
	else:
		$chaseTrack.pitch_scale = 0.1

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


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Походу ответ прячется за этой дверью...")
		$hud/tasks.text = "Текущее задание:\nНайди ключ и топор"
		$Area3D.queue_free()

func _on_monster_trigger_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$track.play()
		_changeTxt("Лучше быть осторожнее... Кажется что то может быть в этих лабиринтах...")
		$zomb.can_move = true
		$monsterTrigger.queue_free()

func _on_triggkey_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$pickUpKey.play()
		door += 1
		
		if door == 2:
			_changeTxt("Итак вроде бы всё, пора открыть ту дверь.")
			$hud/tasks.text = "Текущее задание:\nОткрой дверь"
		else:
			_changeTxt("А вот и ключи, остался только топор.")
			
		$key.queue_free()


func _on_axetrugg_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$pickUpAxe.play()
		door += 1
		
		if door == 2:
			_changeTxt("Итак вроде бы всё, пора открыть ту дверь.")
			$hud/tasks.text = "Текущее задание:\nОткрой дверь"
		else:
			_changeTxt("А вот и топор, остались только ключи.")
			
		$axe.queue_free()


func _on_exit_door_trigger_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		if door == 2:
			if not opened:
				noMore = false
				$player.canLook = false
				$player.canMove = false
				$zomb.queue_free()
				opened = true
				$doorOpen.play()
				var tween = get_tree().create_tween()
				tween.tween_property($hud/bg, "self_modulate:a", 1, 1)
				await TimerRoot.delay(6)
				var tween2 = get_tree().create_tween()
				tween2.tween_property($hud/bg, "self_modulate:a", 0, 1)
				_changeTxt("...")
				$player.canLook = true
				$player.canMove = true
				$hud/tasks.text = "Текущее задание:\nВойди"
				var material = StandardMaterial3D.new()
				material.albedo_texture = load("res://hell door 2-2 alt.png")
				material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
				$exitDoor.set_surface_override_material(0, material)
				$desk.visible = false
				$desk2.visible = false
				$lock.visible = false
				$exitDoor/StaticBody3D/CollisionShape3D.disabled = true

func _on_death_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		canPause = false
		$track.stop()
		$chaseTrack.stop()
		$zomb/loop.stop()
		$death.visible = true
		if MainScript.lights: $death/AnimationPlayer.play("jump")
		$ded.play()
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()


func _on_ending_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		if not cult:
			canPause = false
			$hud/tasks.text = ""
			if MainScript.progress == 1:
				MainScript.progress = 2
				MainScript.lvl2 = 0
				MainScript.save_data()
			else:
				MainScript.lvl2 = 0
				MainScript.save_data()
				
			MainScript.backFromLevel = true
			$End.visible = true
			$exitDoor2.visible = true
			$exitDoor3.visible = false
			$exitDoor2/StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
			$exitDoor/StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
			$exitDoor3/StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
			$static.play()
			$ambience.stop()
			$chaseTrack.stop()
			$track.stop()
			await get_tree().create_timer(1).timeout
			$End.visible = false
			$track.stream = load("res://Cult.wav");
			$track.play()
			$ambience.stream = load("res://ERROR.wav");
			$ambience.pitch_scale = 0.25
			$ambience.play()
			$static.stop()
			$laugh.play()
			$laugh2.play()
			$ohNo.play()
			$ohNo2.play()
			cult = true
			$cult1.visible = true
			$cult2.visible = true
			$cult3.visible = true
			$cult4.visible = true
			$cult5.visible = true
			$cult6.visible = true
			await get_tree().create_timer(6).timeout
			$ambience.stop()
			$track.stop()
			$laugh.stop()
			$laugh2.stop()
			$ohNo.stop()
			$ohNo2.stop()
			
			$endingScream.play()
			
			$End.visible = true
			
			if MainScript.lights:
				$End/text.visible = true
				$End/text2.visible = true
				$End/text3.visible = true
				
			$End/TextureRect.visible = true
			
			await get_tree().create_timer(3).timeout
			$End/bg.visible = true
			$endingScream.stop()
			
			$line.play()
			await get_tree().create_timer(0.6).timeout
			$End/line.self_modulate.a = 0.2
			await get_tree().create_timer(0.6).timeout
			$End/line.self_modulate.a = 0.4
			await get_tree().create_timer(0.6).timeout
			$End/line.self_modulate.a = 0.6
			await get_tree().create_timer(0.6).timeout
			$End/line.self_modulate.a = 0.8
			await get_tree().create_timer(0.6).timeout
			$End/line.self_modulate.a = 1
			await get_tree().create_timer(6).timeout
			get_tree().change_scene_to_file('res://mainMenu.tscn')
