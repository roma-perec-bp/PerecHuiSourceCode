extends Node3D

var display = ""
var current_char = 0
var cur_lenght = 0
var typedTxt = ""
var perRn = false
var pependLine = false

var perecLine = -1

var canPause = true

var paperIn = false
var canPaper = true
var curPaper = 0

var textArray:Array[String] = [
	'Оно прекрасно...Моё логово!\nНе думал что с помощью некоторых билдов которые тут есть я создам это!\nОно мне нужно чтобы оставлять тут трупы людей если я буду сытым иногда, ну или как награду оставить думаю тоже можно! И неважно живые или нет, буду хранить здесь!\nДумаю буду иногда такие заметки писать для себя, люблю такое.',
	'Нашел этого бегающего манекена там и этих двух баб!\nКрасный кста был мелким мужиком...\nМанекен что-то был как-то напуган... будто его кто-то травмировал, но думаю он рад тому что теперь он на белом свете!',
	'Этот скелет имел форму похожую на мою...\nОна даже как-то странно функционировала, но все равно я как-то вытащил кожу из этого скелета и поглотил. О я еще этого парня нашел, у него дырка в башке была и я его руку туда засунул и думаю выглядит красиво!',
	'Я без понятия что это, думаю какая-то шутка которой ну... 7 лет наверное?\nКстати на скамейке я нашел кое какие штуки, а именно синий волос и деталь какого-то лего под скамейкой. Что это значит?',
	'Когда я сыт но имеется достаточно живых людей, я просто их ставлю в эти клетки и в будущем поглощаю их души.\nИнтересно но иногда когда я сюда прихожу они уже мертвы! Либо от нехватки пищи либо они друг друга поубивали... Оба варианта мне нравятся!',
	'Мой создатель...\nЯ его решил сюда поставить как трофей! Мое первое убийство как никак! Я поставил бы туда всё тело, но он был тяжелым, поэтому тут только его голова.',
	'Этих двоих пришлось заманивать в свое логово!\nЭти ребята были забавные, особенно тот круглый\nОни не состояли из плоти или скелета, я иногда эксперементировал с ними и делал подобия своих существ, они были агрессивными и к сожалению быстро падали так как их части всегда отваливались...\nО кстати я еще этот ходячий пельмень нашел, он пытался как то обороняться но я просто его убил... весело!',
	'Наконец-то фембой у меня в руках!\nПо словам зомба, он пытался убежать и даже дверь в нашу тайную комнату открыл\nПрикольно конечно что он буквально шел на гибель, за нас выполнил работу!\nОстался лишь этот зеленый который не просыпается, а он мне нужен ЖИВЫМ пока еще не поздно!',
	'Не думал что этого будет тяжелее поймать!\nПо словам моих существ, он пытался бороться со всеми, но он не знал что их физически нельзя убить... Но респект за попытку самообороны!',
	'Какие то животные по городу ходили...\nничего интересного так-то, но тот серый кот буквально сам себя убил и выкинул себя в мусорку, реальный приколист!'
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.canMove = false
	_changeTxt("Ухх бля... Моя голова...")
	await TimerRoot.delay(4)
	_changeTxt("Что произошло...?")
	await TimerRoot.delay(4)
	_changeTxt("Г-г...?")
	await TimerRoot.delay(1)
	_changeTxt("Где я...?")
	var tween = get_tree().create_tween()
	tween.tween_property($hud/bg, "self_modulate:a", 0, 6)
	$track.play()
	await TimerRoot.delay(3)
	_changeTxt("Что это сука за место!?")
	$hud/tasks.text = "Текущее задание:\nИсследуй место"
	$player.canMove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
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
			$hud/paper/Label.text = textArray[curPaper]
		else:
			canPaper = true
			$player.canMove = true
			$hud/paper.visible = false
			$hud/instruct.visible = true


func _changeTxt(text: String, perec: bool = false, pepEnd: bool = false, altAudio: String = ""):
	$hud/dialogueBg.visible = true
	$hud/nextDialogue.stop()
	display = ""
	current_char = 0
	cur_lenght = len(text)
	typedTxt = text
	perRn = perec
	pependLine = pepEnd
	$hud/dialogueTxt.text = ""
	
	if perRn:
		$hud/dialogueTxt.set("theme_override_colors/font_color", Color(0.66, 0, 0))
		if altAudio == "":
			perecLine += 1
			$dialogue.stream = load("res://perec-31-NEW/pep"+str(perecLine)+".wav");
		else:
			$dialogue.stream = load("res://perec-31-NEW/pep"+str(altAudio)+".wav");
		$dialogue.play()
	else:
		$hud/dialogueTxt.set("theme_override_colors/font_color", Color(1, 1, 1))
	
	$hud/nextCharacter.set_wait_time(0.05)
	$hud/nextCharacter.start()


func _on_next_character_timeout() -> void:
	if current_char < cur_lenght:
		var next_char = typedTxt[current_char]
		display += next_char
		
		$hud/dialogueTxt.text = display
		current_char += 1
		if not perRn: $player/talk.play()
	else:
		$hud/nextCharacter.stop()
		$hud/nextDialogue.one_shot = true
		$hud/nextDialogue.set_wait_time(2)
		if not perRn: $hud/nextDialogue.start()
		if pependLine: $hud/nextDialogue.start()

func _on_next_dialogue_timeout() -> void:
	$hud/dialogueTxt.text = ""
	$hud/dialogueBg.visible = false


func _on_dialgoue_1_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Боже что за пиздец...")
		$dialgoue1.queue_free()


func _on_dialgoue_2_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Ебанный обосрал... че за колония трупов?")
		$dialgoue2.queue_free()


func _on_dialgoue_3_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Да почему тут так много трупов? Где я ебучий случай?!")
		$dialgoue3.queue_free()


func _on_dialgoue_4_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Мне пиздец как это не нравится...")
		$dialgoue4.queue_free()


func _on_dialgoue_5_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$dialgoue5.queue_free()
		$track.stream = load("res://Weird Feelings.wav");
		$track.play()
		_changeTxt("Нихуя Катя в банке! И почему та банка пустая?")
		await TimerRoot.delay(4)
		_changeTxt("Что то тут не так...")


func _on_dialgoue_6_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("УМБРА! Ну всё, игры реально кончились чмо...")
		$dialgoue6.queue_free()


func _on_dialgoue_7_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Что за... там кто то стоит..?")
		$hud/tasks.text = "Текущее задание:\nПоговори с ним"
		$dialgoue7.queue_free()
		$track.stream = load("res://x.wav");
		$track.pitch_scale = 0.6
		$track.play()


func _on_start_dialouge_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$startDialouge.queue_free()
		$player.canMove = false
		$player.canLook = false
		$cutCam.current = true
		$roma_perec.visible = true
		$hud/tasks.text = ""
		_changeTxt("Ого! Все таки проснулся, даже раньше чем я думал!", true)
		await TimerRoot.delay(4)
		_changeTxt("Ты кто такой сука?")
		$cutCam3.current = true
		await TimerRoot.delay(2)
		$cutCam.current = true
		_changeTxt("Меня звать перец.хуй, по крайней мере меня так назвали.", true)
		await TimerRoot.delay(5)
		_changeTxt("Ага... и где я бля?")
		$cutCam3.current = true
		await TimerRoot.delay(3)
		$cutCam.current = true
		_changeTxt("Ты в моем логове, и ты здесь умрешь!", true)
		await TimerRoot.delay(4)
		_changeTxt("Схуяли?")
		$cutCam3.current = true
		await TimerRoot.delay(2)
		$cutCam.current = true
		_changeTxt("Видишь ли... это началось с того что я ээээ это секретные секреты ХВАТИТ ЧИТАТЬ КОД!", true)
		await TimerRoot.delay(1.6)
		_changeTxt("И вообще хули тут так много трупов, что ты вообще такое, почему Я здесь блять?")
		$cutCam3.current = true
		await TimerRoot.delay(3)
		$cutCam.current = true
		_changeTxt("ТИХА!", true)
		await TimerRoot.delay(2)
		$cutCam.current = true
		_changeTxt("Дай мне рассказать свою историю!", true)
		await TimerRoot.delay(3)
		$cutCam.current = true
		_changeTxt(" Кхм... так вот...", true)
		await TimerRoot.delay(2)
		_changeTxt("")
		var tween = get_tree().create_tween()
		tween.tween_property($hud/bg, "self_modulate:a", 1, 3)
		var tween2 = get_tree().create_tween()
		tween2.tween_property($ambience, "volume_db", -80, 3)
		var tween3 = get_tree().create_tween()
		tween3.tween_property($track, "volume_db", -80, 3)
		await TimerRoot.delay(3)
		$hud/VideoStreamPlayer.play()


func _on_escape_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$escape.queue_free()
		var no = get_tree().create_tween()
		no.tween_property($track, "pitch_scale", 0.1, 10)
		$player.canMove = false
		$player.canLook = false
		$cutCam2.current = true
		_changeTxt("НАДЕЮСЬ ТЫ ТАМ ВСЕ ЕЩЕ СТОИШЬ И ВЫТАСКИВАЕШЬ СВОЮ ДУШУ! ВЕДЬ ЕСЛИ ТЫ УЙДЕШЬ... Я ОЧЕНЬ СИЛЬНО РАЗОЗЛЮСЬ!", true)
		await TimerRoot.delay(10)
		$player.canMove = true
		$player.canLook = true
		$player/Camera3D.current = true
		_changeTxt("Надеюсь он не заметит моё отсутствие...")


func _on_exit_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$player.canMove = false
		$player.canLook = false
		canPause = false
		$exit.queue_free()
		$exit2.play()
		var tweensex = get_tree().create_tween()
		tweensex.tween_property($hud/bg, "self_modulate:a", 1, 3)
		var sextween2 = get_tree().create_tween()
		sextween2.tween_property($ambience, "volume_db", -80, 3)
		var tweeen3 = get_tree().create_tween()
		tweeen3.tween_property($track, "volume_db", -80, 3)
		await get_tree().create_timer(6).timeout
		get_tree().change_scene_to_file('res://level3-2.tscn')


func _on_dialgoue_8_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Ебануться сколько тут трупов... Я что в морге?")
		$dialgoue8.queue_free()


func _on_dialgoue_9_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("У меня плохое предчувствие...")
		$dialgoue9.queue_free()


func _on_dialgoue_10_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		$dialgoue10.queue_free()
		$ittdw_egg._activate_text()
		await TimerRoot.delay(2)
		_changeTxt("Что за? А это тут откуда?\nЭто уже слишком локально...")


func _on_dialgoue_11_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Ебать пх, шо ты голова.")
		$dialgoue11.queue_free()


func _on_dialgoue_12_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		_changeTxt("Максат! Всё таки его сварили...")
		$dialgoue12.queue_free()


func _on_video_stream_player_finished() -> void:
	$cutCam3.current = true
	$hud/VideoStreamPlayer.visible = false
	var tweenHyu = get_tree().create_tween()
	tweenHyu.tween_property($hud/bg, "self_modulate:a", 0, 3)
	var tweenPonos = get_tree().create_tween()
	tweenPonos.tween_property($ambience, "volume_db", 0, 3)
	var tween3s = get_tree().create_tween()
	tween3s.tween_property($track, "volume_db", 0, 3)
	$track.play(0)
	await TimerRoot.delay(3)
	_changeTxt("Бля может к сути уже перейдешь!? Я уже заебался слушать твой ебучий грустный рассказ.")
	$cutCam3.current = true
	await TimerRoot.delay(5)
	$cutCam.current = true
	_changeTxt("Хорошо хорошо...", true)
	await TimerRoot.delay(2)
	_changeTxt("Чуть позже я начал иследовать папку в которой я родился, и что это за штука брутал пиздец.", true)
	await TimerRoot.delay(7)
	_changeTxt("Как оказалось, это некий мод с каким то перцем похожим на меня и каким то нефором.", true)
	await TimerRoot.delay(7)
	_changeTxt("Видимо вот откуда у меня этот образ.", true)
	await TimerRoot.delay(3)
	_changeTxt("Поискав больше информации, я узнал создателей этого детища, и как оказалось... они закончили с этим, проектом так сказать!", true)
	await TimerRoot.delay(9)
	_changeTxt("И я не хотел чтобы это добро просто так оставалось... Я решил захватить души двух особых людей!!", true)
	await TimerRoot.delay(7)
	_changeTxt("Фембой со средой и Ты Шрекоподобная хуйня!", true)
	await TimerRoot.delay(4)
	_changeTxt("У фембоя была энергия связанная с его ремейком бп, пропадать ей просто так я не позволю!", true, false, "_alt")
	await TimerRoot.delay(6)
	_changeTxt("А у тебя, имеются права на бп, и ты с ним очень хорошо связан!", true)
	await TimerRoot.delay(6)
	_changeTxt("А значит с вами обоими, я стану больше и могучим! Да и вы, ваши души это ну очень вкусный корм.", true)
	await TimerRoot.delay(10)
	_changeTxt("Ок и?")
	$cutCam3.current = true
	await TimerRoot.delay(2)
	$cutCam.current = true
	_changeTxt("Кейта я уже захватил, остался только ты!", true)
	await TimerRoot.delay(4)
	_changeTxt("Давай обойдемся мирно и ты по-хорошему отдашь мне свою душу!", true)
	await TimerRoot.delay(4)
	_changeTxt("Эм... нет умри.")
	$cutCam3.current = true
	await TimerRoot.delay(2)
	$cutCam.current = true
	_changeTxt("У тебя нет выбора, ты остюда не уйдешь!", true)
	await TimerRoot.delay(4)
	$player/Camera3D.current = true
	$roma_perec.visible = false
	_changeTxt("Стой тут, вытаскивай свою душу, а мне надо на минутку отойти.", true, true)
	await TimerRoot.delay(4)
	$bye_hui.play("sequence")
	await TimerRoot.delay(2)
	$AudioStreamPlayer.play()
	_changeTxt("Это мой шанс съебаться!")
	$hud/tasks.text = "Текущее задание:\nУходи отсюда"
	$player.canMove = true
	$player.canLook = true
	await TimerRoot.delay(2)
	$AudioStreamPlayer2.play()


func _on_paper_trigger_1_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 0


func _on_paper_trigger_1_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 0


func _on_paper_trigger_2_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 1


func _on_paper_trigger_2_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 1


func _on_paper_trigger_3_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 2


func _on_paper_trigger_3_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 2


func _on_paper_trigger_4_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 3


func _on_paper_trigger_4_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 3


func _on_paper_trigger_5_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 4


func _on_paper_trigger_5_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 4


func _on_paper_trigger_6_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 5


func _on_paper_trigger_6_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 5


func _on_paper_trigger_7_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 6


func _on_paper_trigger_7_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 6


func _on_paper_trigger_8_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 7


func _on_paper_trigger_8_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 7


func _on_paper_trigger_9_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 8


func _on_paper_trigger_9_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 8


func _on_paper_trigger_10_body_entered(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = true
		paperIn = true
		curPaper = 9


func _on_paper_trigger_10_body_exited(body: Node3D) -> void:
	if body.name == "player":
		$hud/instruct.visible = false
		paperIn = false
		curPaper = 9
