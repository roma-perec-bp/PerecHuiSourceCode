extends Node3D

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""
var inDialogue = false

var canMove:bool = false
var firstMas:bool = true
var secondMas:bool = true
var masterVal:int = 1
var canGo:bool = true

var canDoor:bool = false
var canDoorLook:bool = false
var canExit:bool = false

var canMaster:bool = false
var mastering:bool = false

var windowVal:int = 0
var canWindows:bool = false
var canLook:bool = false

var scared:bool = true

var canFlush:bool = false

var foodInteract:bool = false
var fridgeInteract:bool = false
var kuruInteract:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.canLook = false
	$player.canMove = false
	await TimerRoot.delay(3)
	_changeTxt("Поверить не могу что Рома Перец отменен и разоблачен...")
	await TimerRoot.delay(4)
	var tween = get_tree().create_tween()
	tween.tween_property($hud/bg, "self_modulate:a", 0, 6)
	$track.play()
	_changeTxt("Ну и ладно, пойду лучше своими делами займусь. Позже разберусь с этим.")
	await TimerRoot.delay(5)
	$player.canMove = true
	$player.canLook = true
	$hud/tasks.text = "Текущее задание:\nСядь за стол компьютера"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		TimerRoot.set_paused(true)
		$hud/pause.pause()
		$hud/pause.visible = true
		
	if canFlush:
		if Input.is_action_just_pressed("use"):
			$toilet/snd.play()
			
	if kuruInteract && $dakimakuru/VisibleOnScreenNotifier3D.is_on_screen() && !inDialogue:
		if Input.is_action_just_pressed("use"):
			_changeTxt("Это моя собственность! Оно стоило 5 рублей.")
			
	if foodInteract && $tableKitchen/VisibleOnScreenNotifier3D.is_on_screen() && !inDialogue:
		if Input.is_action_just_pressed("use"):
			_changeTxt("Тут всё протухло...")
			
	if fridgeInteract && $fridge/VisibleOnScreenNotifier3D.is_on_screen() && !inDialogue:
		if Input.is_action_just_pressed("use"):
			_changeTxt("В холодильнике пусто. Как всегда...")
	
	if canMaster:
		if Input.is_action_just_pressed("use"):
			master()
			
	if mastering:
		if $hud/masterBar.value >= 0:
			$hud/masterBar.value -= 0.3
			
		if Input.is_action_just_pressed("master"):
			$hud/masterBar.value += 4
			
	if canDoorLook:
		if Input.is_action_just_pressed("use"):
			if canExit:
				var tween = get_tree().create_tween()
				tween.tween_property($hud/bg, "self_modulate:a", 1, 3)
				var tween2 = get_tree().create_tween()
				tween2.tween_property($ambience, "volume_db", -80, 3)
				canExit = false
				canDoor = false
				canDoorLook = false
				$openDoor.play()
				$player.canLook = false
				$player.canMove = false
				await TimerRoot.delay(3)
				get_tree().change_scene_to_file('res://level1-2.tscn')
			else:
				$hud/instruct2.visible = false
				$hud/glazok.visible = true
				canDoor = false
				canDoorLook = false
				canWindows = true
				$player.canLook = false
				$player.canMove = false
				_changeTxt("Странно, за дверью никого не видно...")
				await TimerRoot.delay(3)
				$player.canLook = true
				$player.canMove = true
				$hud/glazok.visible = false
				_changeTxt("Пойду снова в окно посмотрю.")
				$hud/tasks.text = "Текущее задание:\nИди опять на кухню"
				$mainJumpscare.visible = true

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
	$hud/dialogueTxt.text = ""
	$hud/dialogueBg.visible = false
	inDialogue = false

func master():
	$player.canLook = false
	$hud/instruct.visible = false
	canMaster = false
	$masterCam.current = true
	$player.canMove = false
	$hud/masterBar.visible = true
	$hud/masterBar.value = 0
	$hud/masterText.visible = true
	mastering = true
	
func stopMaster():
	$player/Camera3D.current = true
	$player.canLook = true
	$player.canMove = true
	mastering = false
	$hud/masterBar.visible = false
	$hud/masterBar.value = 0
	$hud/masterText.visible = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if canGo:
		if body.name == "player":
			$hud/instruct.visible = true
			canMaster = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if canGo:
		if body.name == "player":
			$hud/instruct.visible = false
			canMaster = false

func _on_master_bar_value_changed(value: float) -> void:
	if value >= 42:
		if masterVal == 1:
			if firstMas:
				canGo = false
				firstMas = false
				$Distract1.play()
				await TimerRoot.delay(1)
				mastering = false
				_changeTxt("Что это был за звук?")
				await TimerRoot.delay(3)
				_changeTxt("Лучше проверить на всякий.")
				$hud/tasks.text = "Текущее задание:\nИди на кухню и посмотри что за окном"
				canWindows = true
				stopMaster()
		
		if masterVal == 2:
			if secondMas:
				canGo = false
				secondMas = false
				$Distract2.play()
				_changeTxt("??????????????????????????")
				await TimerRoot.delay(2)
				mastering = false
				_changeTxt("Да что это такое!")
				await TimerRoot.delay(3)
				_changeTxt("Меня это начинает раздражать.")
				$hud/tasks.text = "Текущее задание:\nПосмотри ещё раз"
				canWindows = true
				stopMaster()

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	if canLook and canWindows:
		if windowVal == 0:
			canWindows = false
			canGo = true
			windowVal += 1
			masterVal += 1
			_changeTxt("Хм... Ничего...")
			$behindGlassJump.visible = true
			await TimerRoot.delay(2)
			$track.stream = load("res://Weird Feelings.wav");
			$track.play()
			_changeTxt("Думаю просто ветер, пойду продолжу тогда.")
			$hud/tasks.text = "Текущее задание:\nИди обратно за компьютер"
		elif windowVal == 1:
			canWindows = false
			windowVal += 1
			$Distract3.play()
			await TimerRoot.delay(1)
			_changeTxt("Ах? Кто это? Сейчас же 3 часа ночи.")
			await TimerRoot.delay(4)
			$track.stream = load("res://Weird Feelings.wav");
			$track.play()
			_changeTxt("Надо посмотреть!")
			$hud/tasks.text = "Текущее задание:\nУзнай кто за дверью"
			canDoor = true
		elif windowVal == 2:
			canWindows = false
			windowVal += 1
			$sus.play()
			$track.stream = load("res://Here.wav");
			$track.play()
			$jump2.play("jump2")
			_changeTxt("ЭТО ЧТО ТАКОЕ?")
			await TimerRoot.delay(3)
			_changeTxt("Нет... это уже серьезно...")
			await TimerRoot.delay(3)
			_changeTxt("Я не могу продолжать свои дела. Я должен понять что это за штука за мной следит...")
			$hud/tasks.text = "Текущее задание:\nИди на улицу и проследи за этой штукой"
			canExit = true
			canDoor = true

func _on_look_area_body_entered(body: Node3D) -> void:
	if body.name == "player":
		canLook = true
		$pointSee.visible = true

func _on_look_area_body_exited(body: Node3D) -> void:
	if body.name == "player":
		canLook = false
		$pointSee.visible = false

func _on_scary_body_entered(body: Node3D) -> void:
	if body.name == "player":
		if scared and windowVal == 1:
			$jump1.play("jump")
			scared = false

func _on_door_trigger_body_entered(body: Node3D) -> void:
	if canDoor:
		if body.name == "player":
			$hud/instruct2.visible = true
			canDoorLook = true

func _on_door_trigger_body_exited(body: Node3D) -> void:
	if canDoor:
		if body.name == "player":
			$hud/instruct2.visible = false
			canDoorLook = false


func _on_toilet_trigger_body_entered(body: Node3D) -> void:
	if body.name == "player":
		canFlush = true


func _on_toilet_trigger_body_exited(body: Node3D) -> void:
	if body.name == "player":
		canFlush = false


func _on_inter_body_entered(body: Node3D) -> void:
	if body.name == "player":
		foodInteract = true


func _on_inter_body_exited(body: Node3D) -> void:
	if body.name == "player":
		foodInteract = false


func _on_frd_body_entered(body: Node3D) -> void:
	if body.name == "player":
		fridgeInteract = true


func _on_frd_body_exited(body: Node3D) -> void:
	if body.name == "player":
		fridgeInteract = false


func _on_sex_toy_body_entered(body: Node3D) -> void:
	if body.name == "player":
		kuruInteract = true


func _on_sex_toy_body_exited(body: Node3D) -> void:
	if body.name == "player":
		kuruInteract = false
