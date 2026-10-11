extends Node3D

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""

var treeCan:bool = false

var tree1:bool = false
var tree2:bool = false
var tree3:bool = false
var tree4:bool = false
var tree5:bool = false
var tree6:bool = false

var startScare = false
var saw = true

var papers:int = 0
var holdsPap:bool = false

var dead = false
var canPause = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainScript.lvl1 = 1
	MainScript.save_data()
	var tween = get_tree().create_tween()
	tween.tween_property($hud/bg, "self_modulate:a", 0, 6)
	_changeTxt("Ну... Была не была.")
	$hud/tasks.text = "Текущее задание:\nИди по тропинке"
	await TimerRoot.delay(3)
	_changeTxt("Надо узнать что это за существо.")
	
func _input(event):
	if holdsPap:
		if event is InputEventKey:
			if event.pressed:
				holdsPap = false
				$player.canMove = true
				$player.canLook = true
				$hud/paper.visible = false
				
				if papers == 6:
					$player.canMove = false
					$player.canLook = true
					$behindGuy.set_position($player/targetTeleport.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if startScare:
		$guy1.move_and_slide()
		$guy2.move_and_slide()
		$guy3.move_and_slide()
		$guy4.move_and_slide()
		$guy5.move_and_slide()
		$guy6.move_and_slide()
	
	if Input.is_action_just_pressed("escape") and canPause:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
		
	if startScare and MainScript.lights:
		$player/Camera3D.h_offset = randf_range(0,0.5)
		$player/Camera3D.v_offset = randf_range(0,0.5)
		
	if dead and MainScript.lights:
		$scaryDeath/text.position.x = randf_range(0,640)
		$scaryDeath/text.position.y = randf_range(0,480)
		
		$scaryDeath/text2.position.x = randf_range(0,640)
		$scaryDeath/text2.position.y = randf_range(0,480)
		
		$scaryDeath/text3.position.x = randf_range(0,640)
		$scaryDeath/text3.position.y = randf_range(0,480)
	
	if Input.is_action_just_pressed("use"):
		if treeCan:
			$paper.play()
			if tree1:
				$treeList1/treeTrigger1.queue_free()
				$wall.queue_free()
				$wall2.queue_free()
				$wall3.queue_free()
				$treeList1.texture = load('res://tree_empty.png')
				treeCan = false
				tree1 = false
				papers += 1
				
				holdsPap = true
				$player.canMove = false
				$player.canLook = false
				$hud/paper.visible = true
				
				_changeTxt("Видимо этих бумажек еще несколько.")
				$hud/tasks.text = "Текущее задание:\nСобери все записки\n"+str(papers)+"/6 Бумажек"
				await TimerRoot.delay(3)
				_changeTxt("Попробую найти их всех.")
				
			if tree2:
				$treeList2/treeTrigger2.queue_free()
				$treeList2.texture = load('res://tree_empty.png')
				papers += 1
				$hud/tasks.text = "Текущее задание:\nСобери все записки\n"+str(papers)+"/6 Бумажек"
				tree2 = false
				holdsPap = true
				$player.canMove = false
				$player.canLook = false
				$hud/paper.texture = load('res://paper'+str(papers)+'.png')
				$hud/paper.visible = true
				
			if tree3:
				$treeList3/treeTrigger3.queue_free()
				$treeList3.texture = load('res://tree_empty.png')
				papers += 1
				$hud/tasks.text = "Текущее задание:\nСобери все записки\n"+str(papers)+"/6 Бумажек"
				tree3 = false
				holdsPap = true
				$player.canMove = false
				$player.canLook = false
				$hud/paper.texture = load('res://paper'+str(papers)+'.png')
				$hud/paper.visible = true
				
			if tree4:
				$treeList4/treeTrigger4.queue_free()
				$treeList4.texture = load('res://tree_empty.png')
				papers += 1
				$hud/tasks.text = "Текущее задание:\nСобери все записки\n"+str(papers)+"/6 Бумажек"
				tree4 = false
				holdsPap = true
				$player.canMove = false
				$player.canLook = false
				$hud/paper.texture = load('res://paper'+str(papers)+'.png')
				$hud/paper.visible = true
				
			if tree5:
				$treeList5/treeTrigger5.queue_free()
				$treeList5.texture = load('res://tree_empty.png')
				papers += 1
				$hud/tasks.text = "Текущее задание:\nСобери все записки\n"+str(papers)+"/6 Бумажек"
				tree5 = false
				holdsPap = true
				$player.canMove = false
				$player.canLook = false
				$hud/paper.texture = load('res://paper'+str(papers)+'.png')
				$hud/paper.visible = true
				
			if tree6:
				$treeList6/treeTrigger6.queue_free()
				$treeList6.texture = load('res://tree_empty.png')
				papers += 1
				$hud/tasks.text = "Текущее задание:\nСобери все записки\n"+str(papers)+"/6 Бумажек"
				tree6 = false
				holdsPap = true
				$player.canMove = false
				$player.canLook = false
				$hud/paper.texture = load('res://paper'+str(papers)+'.png')
				$hud/paper.visible = true
				
			if papers == 6:
				$ambience.stop()
				$track.stop()

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

func _on_trigger_1_body_entered(body: Node3D) -> void:
	if body.name == "player":
		_changeTxt("Здесь так темно...")
		$trigger1.queue_free()

func _on_trigger_2_body_entered(body: Node3D) -> void:
	if body.name == "player":
		_changeTxt("Хм... Дальше видимо только направо идти.")
		$trigger2.queue_free()

func _on_trigger_3_body_entered(body: Node3D) -> void:
	if body.name == "player":
		_changeTxt("Что за бумажка?")
		$trigger3.queue_free()

func _on_tree_trigger_1_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		treeCan = true
		tree1 = true

func _on_tree_trigger_1_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		treeCan = false
		tree1 = false

func _on_tree_trigger_2_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		treeCan = true
		tree2 = true

func _on_tree_trigger_2_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		treeCan = false
		tree2 = false

func _on_tree_trigger_3_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		treeCan = true
		tree3 = true

func _on_tree_trigger_3_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		treeCan = false
		tree3 = false

func _on_tree_trigger_4_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		treeCan = true
		tree4 = true

func _on_tree_trigger_4_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		treeCan = false
		tree4 = false

func _on_tree_trigger_5_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		treeCan = true
		tree5 = true

func _on_tree_trigger_5_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		treeCan = false
		tree5 = false

func _on_tree_trigger_6_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		treeCan = true
		tree6 = true


func _on_tree_trigger_6_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		treeCan = false
		tree6 = false


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	if papers == 6 and saw:
		saw = false
		await TimerRoot.delay(1)
		$behindGuy.play("laugh")
		$laugh.play()
		await TimerRoot.delay(4)
		
		$guy1.set_position($behindGuy.global_position)
		$guy2.set_position($behindGuy.global_position)
		$guy3.set_position($behindGuy.global_position)
		$guy4.set_position($behindGuy.global_position)
		$guy5.set_position($behindGuy.global_position)
		$guy6.set_position($behindGuy.global_position)
		
		$behindGuy.queue_free()
		$player.canMove = true
		startScare = true
		_changeTxt("ЧТО ПРОИСХОДИТ!?")
		$ambience.stream = load("res://ERROR.wav");
		$ambience.pitch_scale = 0.25
		$ambience.play()
		var no = get_tree().create_tween()
		no.tween_property($ambience, "pitch_scale", 4, 242)
		
		$track.stream = load("res://behind.wav");
		$track.play()
		
		$jump.play()
		
		$hud/tasks.text = "Текущее задание:\nБЕГИ"
		
		$DirectionalLight3D.light_color = Color(1, 0, 0)
		$WorldEnvironment.get_environment().ambient_light_color = Color(1, 0, 0)
		
		$chaseGuy.set_position($chasetel.global_position)
		$chaseGuy.can_move = true


func _on_death_body_entered(body: Node3D) -> void:
	if body.name == "player":
		if dead == false:
			canPause = false
			$ambience.stop()
			$track.stop()
			if MainScript.progress == 0:
				MainScript.progress = 1
				MainScript.lvl1 = 0
				MainScript.save_data()
			else:
				MainScript.lvl1 = 0
				MainScript.save_data()
				
			MainScript.backFromLevel = true
				
			$scaryDeath.visible = true
			dead = true
			$scar.play()
			$scaryDeath/AnimationPlayer.play("SCARY")
			
			if !MainScript.lights:
				$scaryDeath/text.visible = false
				$scaryDeath/text2.visible = false
				$scaryDeath/text3.visible = false
				
			await get_tree().create_timer(6).timeout
			$scaryDeath/TextureRect.visible = false
			$scaryDeath/text.visible = false
			$scaryDeath/text2.visible = false
			$scaryDeath/text3.visible = false
			$scar.stop()
			await get_tree().create_timer(3).timeout
			$soul.play()
			$scaryDeath/line.self_modulate.a = 0.2
			await get_tree().create_timer(0.6).timeout
			$scaryDeath/line.self_modulate.a = 0.4
			await get_tree().create_timer(0.6).timeout
			$scaryDeath/line.self_modulate.a = 0.6
			await get_tree().create_timer(0.6).timeout
			$scaryDeath/line.self_modulate.a = 0.8
			await get_tree().create_timer(0.6).timeout
			$scaryDeath/line.self_modulate.a = 1
			await get_tree().create_timer(6).timeout
			get_tree().change_scene_to_file('res://mainMenu.tscn')
