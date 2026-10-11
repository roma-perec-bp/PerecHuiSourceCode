extends Node3D

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""
var inDialogue = false

var canSit = true
var tea = false
var door = false
var canScare = false

var act = false

var closed = false
var jumspscared = false

var looker:bool = false

var canPause = true

var canFlush:bool = false

var foodInteract:bool = false
var fridgeInteract:bool = false
var kuruInteract:bool = false
var toiletCount:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.canMove = false
	$player.canLook = false
	await TimerRoot.delay(3)
	_changeTxt("Итак, сценарий к бп реплантед почти готов!")
	await TimerRoot.delay(4)
	_changeTxt("Осталось пару деталей и можно делать спрайты и звать еще больше людей!\nАх этот день просто прекрасен!")
	await TimerRoot.delay(6)
	_changeTxt("Только Рома что то даже не читает мои сообщения, да и вообще оффлайн весь день был почему то...")
	await TimerRoot.delay(6)
	var tween = get_tree().create_tween()
	tween.tween_property($hud/bg, "self_modulate:a", 0, 6)
	$track.play()
	_changeTxt("Но да ладно, пойду лучше закончу сценарий.")
	await TimerRoot.delay(4)
	$player.canMove = true
	$player.canLook = true
	$hud/tasks.text = "Текущее задание:\nСядь за стол компьютера"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if jumspscared and MainScript.lights:
		$player/Camera3D.h_offset = randf_range(0,0.1)
		$player/Camera3D.v_offset = randf_range(0,0.1)

	if Input.is_action_just_pressed("escape") and canPause:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
		
	if canFlush:
		if toiletCount <= 16:
			if Input.is_action_just_pressed("use"):
				toiletCount += 1
				$toilet/snd.play()
		else:
			if Input.is_action_just_pressed("use") && !inDialogue:
				_changeTxt("Хватит")
			
			
	if kuruInteract && $dakimakuru/VisibleOnScreenNotifier3D.is_on_screen() && !inDialogue:
		if Input.is_action_just_pressed("use"):
			_changeTxt("Боже что за ужас! Надо бы потом перерисовать...")
			
	if foodInteract && $teaTable/VisibleOnScreenNotifier3D.is_on_screen() && !inDialogue:
		if Input.is_action_just_pressed("use"):
			_changeTxt("Обед, но тут не особо уютно...")
			
	if fridgeInteract && $fridge/VisibleOnScreenNotifier3D.is_on_screen() && !inDialogue:
		if Input.is_action_just_pressed("use"):
			_changeTxt("Холодильник закрыт? Я его не могу открыть?")
		
	if act:
		if Input.is_action_just_pressed("use"):
			if tea:
				tea = false
				act = false
				$kettle.play()
				$tea.play()
				$hud/instruct.visible = false
				$hud/tasks.text = "Текущее задание:\nПодожди пока чайник не закипит"
				await TimerRoot.delay(10)
				$doorbell.play()
				await TimerRoot.delay(3)
				_changeTxt("Хм? Кто это может быть?")
				door = true
				$hud/tasks.text = "Текущее задание:\nПосмотри что за входной дверью"
			elif door:
				act = false
				$hud/instruct.visible = false
				door = false
				$doorOpen.play()
				var material = StandardMaterial3D.new()
				material.albedo_texture = load("res://exit door 1-1 opene.png")
				material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
				$doorExit.set_surface_override_material(0, material)
				_changeTxt("Хм... Никого вроде бы...")
				await TimerRoot.delay(5)
				$doorClose.play()
				var material2 = StandardMaterial3D.new()
				material2.albedo_texture = load("res://exit door 1-1.png")
				material2.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
				material2.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
				$doorExit.set_surface_override_material(0, material2)
				$track.stream = load("res://Weird Feelings.wav");
				$track.play()
				_changeTxt("Ну и ладно.")
				$hud/tasks.text = "Текущее задание:\nПодожди снова пока чайник не закипит"
				await TimerRoot.delay(20)
				$doorbell.play()
				await TimerRoot.delay(1)
				$doorknock.play()
				await TimerRoot.delay(2)
				_changeTxt("Опять?")
				$doorknock2.play()
				await TimerRoot.delay(2)
				_changeTxt("Да кто это..?")
				await TimerRoot.delay(2.9)
				canScare = true
				$hud/tasks.text = "Текущее задание:\nПосмотри ещё раз"
			elif canScare:
				act = false
				canScare = false
				$hud/instruct.visible = false
				$doorOpen.play()
				var material = StandardMaterial3D.new()
				material.albedo_texture = load("res://exit door 1-1 opene.png")
				material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
				$doorExit.set_surface_override_material(0, material)
				#$outsidelook.visible = false
				$fake_exit.visible = false
				$peaHouseFloors/fakeFloor.visible = false
				$peaHouseFloors/fakeFloor2.visible = false
				$peaHouseFloors/fakeFloor3.visible = false
				$peaHouseFloors/fakeFloor4.visible = false
				$peaHouseFloors/fakeFloor5.visible = false
				$peaHouseWalls/fakewall.visible = false
				$peaHouseWalls/fakewall2.visible = false
				$peaHouseWalls/fakewall3.visible = false
				$peaHouseWalls/fakewall4.visible = false
				$peaHouseWalls/fakewall5.visible = false
				$peaHouseWalls/fakewall6.visible = false
				$peaHouseWalls/fakewall7.visible = false
				$peaHouseFloors/fake_flat.visible = false
				$peaHouseFloors/fake_flat2.visible = false
				$peaHouseFloors/fake_flat3.visible = false
				$peaHouseFloors/fake_flat4.visible = false
				$peaHouseFloors/fake_flat5.visible = false
				$"NavigationRegion3D/hell/hell floor lol".visible = true
				$"NavigationRegion3D/hell/hell wall2 lol".visible = true
				$"NavigationRegion3D/hell/hell floor2 lol".visible = true
				$"NavigationRegion3D/hell/hell floor3 lol".visible = true
				$NavigationRegion3D/hell/open_wall.visible = true
				$looker.visible = true
				$"peaHouseWalls/wall normal38".visible = true
				$"peaHouseWalls/wall normal39".visible = true
				$"peaHouseWalls/wall normal40".visible = true
				$"peaHouseWalls/wall normal42".visible = true
				$peaHouseWalls/under.visible = false
				$peaHouseWalls/lol.visible = true
				looker = true
				$track.stream = load("res://Here.wav");
				$track.play()
				await TimerRoot.delay(1)
				_changeTxt("????????")
				await TimerRoot.delay(2)
				_changeTxt("ЧТО С МОИМ ПОДЪЕЗДОМ??!?!")
				await TimerRoot.delay(3)
				_changeTxt("...")
				$doorExit/StaticBody3D/CollisionShape3D.disabled = true
				$hud/tasks.text = "Текущее задание:\nВойди"

func _changeTxt(text: String):
	$hud/dialogueBg.visible = true
	$hud/nextDialogue.stop()
	display = ""
	inDialogue = true
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
	inDialogue = false
	$hud/dialogueTxt.text = ""
	$hud/dialogueBg.visible = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if canSit:
		if body.name == 'player':
			canSit = false
			_changeTxt("Ммммм нет... Я пока не могу продолжать работу...")
			await TimerRoot.delay(4)
			_changeTxt("Мне нужен ЧАЙ!")
			$hud/tasks.text = "Текущее задание:\nИди на кухню и поставь чайник для чая"
			tea = true


func _on_kettle_trigger_body_entered(body: Node3D) -> void:
	if body.name == 'player' and tea:
		act = true
		$hud/instruct.visible = true

func _on_kettle_trigger_body_exited(body: Node3D) -> void:
	if body.name == 'player' and tea:
		act = false
		$hud/instruct.visible = false

func _on_door_trigger_body_entered(body: Node3D) -> void:
	if body.name == 'player' and (door or canScare):
		act = true
		$hud/instruct.visible = true

func _on_door_trigger_body_exited(body: Node3D) -> void:
	if body.name == 'player' and (door or canScare):
		act = false
		$hud/instruct.visible = false


func _on_trigger_close_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		if not closed:
			closed = true
			$ambience.stop()
			$track.stop()
			$kettle.stop()
			$doorClose.play()
			var material2 = StandardMaterial3D.new()
			material2.albedo_texture = load("res://exit door 1-1.png")
			material2.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
			material2.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
			$doorExitSecond.set_surface_override_material(0, material2)
			$doorExit/StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
			$doorExitSecond/StaticBody3D/CollisionShape3D.set_deferred("disabled", false)
			_changeTxt("???")
			$hud/tasks.text = "Текущее задание:\nиди"
			await TimerRoot.delay(2)
			_changeTxt("бля")

func _on_humscare_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		if not jumspscared:
			jumspscared = true
			_changeTxt("ЁП-ТВОЮ МАТЬ ЧТО ЭТО!?")
			$fire.light_energy = 1
			var tween = get_tree().create_tween()
			tween.tween_property($fire, "light_energy", 0, 1)
			$SpotLight3D.light_energy = 1
			var tween2 = get_tree().create_tween()
			tween2.tween_property($SpotLight3D, "light_energy", 0, 1)
			$track.stream = load("res://You shall not pass.wav");
			$track.play()
			$zomb.can_move = true
			$player.SPEED = 6
			$screa.play()
			$zomb/loop.play()
			$hud/tasks.text = "Текущее задание:\nБЕГИ"
			await TimerRoot.delay(3)
			_changeTxt("НУ НАХЕР")


func _on_death_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$track.stop()
		$screa.stop()
		$zomb/loop.stop()
		$death.visible = true
		if MainScript.lights: $death/AnimationPlayer.play("jump")
		$ded.play()
		canPause = false
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()

func _on_exit_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$track.stop()
		$screa.stop()
		$zomb/loop.stop()
		$zomb.can_move = false
		$player.canMove = false
		$hud/bg.self_modulate.a = 1
		$end.play()
		$end2.play()
		canPause = false
		await get_tree().create_timer(10).timeout
		get_tree().change_scene_to_file('res://level2-2.tscn')


func _on_secret_body_entered(body: Node3D) -> void:
	if body.name == 'player' and looker:
		looker = false
		var tweenFunny = create_tween()	
		tweenFunny.tween_property($looker, "position:y", -100, 6)


func _on_toilet_trigger_body_entered(body: Node3D) -> void:
	if body.name == "player":
		canFlush = true


func _on_toilet_trigger_body_exited(body: Node3D) -> void:
	if body.name == "player":
		canFlush = false


func _on_kuru_tr_body_entered(body: Node3D) -> void:
	if body.name == "player":
		kuruInteract = true


func _on_kuru_tr_body_exited(body: Node3D) -> void:
	if body.name == "player":
		kuruInteract = false


func _on_frd_body_entered(body: Node3D) -> void:
	if body.name == "player":
		fridgeInteract = true


func _on_frd_body_exited(body: Node3D) -> void:
	if body.name == "player":
		fridgeInteract = false


func _on_food_trigger_body_entered(body: Node3D) -> void:
	if body.name == "player":
		foodInteract = true


func _on_food_trigger_body_exited(body: Node3D) -> void:
	if body.name == "player":
		foodInteract = false
