extends Control

var sway_distance: int = 25
var sway_duration: float = 6

var start_y:float
var start_yH1:float
var start_yH2:float
var start_Head:float
var start_victim:float
var start_hui:float

var stateShit:int = 0
var curSelected:int = 0

var username:String
var trans:bool = true
var selectin:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_y = $Main/logo.position.y
	start_Head = $Main/head.position.y
	start_yH1 = $Main/hand.position.y
	start_yH2 = $Main/hand2.position.y
	start_victim = $Selection/select_menu/text.position.y
	start_hui = $Selection/main_menu/Head.position.y
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	$Selection/select_menu/arrow_1.visible = false
	$Selection/select_menu/arrow_2.visible = false
	
	$Selection/main_menu/quit.modulate.a = 0.6
	$Selection/main_menu/options.modulate.a = 0.6
	
	glitch()
	
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	else:
		username = "User"
		
	if MainScript.progress == 3:
		MainScript.backFromLevel = true
		
	if MainScript.backFromLevel:
		$Selection/main_menu/start.release_focus()
		$Selection/main_menu/start.focus_mode = FOCUS_NONE
		$Selection/main_menu/options.release_focus()
		$Selection/main_menu/options.focus_mode = FOCUS_NONE
		$Selection/main_menu/quit.release_focus()
		$Selection/main_menu/quit.focus_mode = FOCUS_NONE
		MainScript.initialized = true
		$Main.visible = false
		$Selection.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property($Selection/shit, "modulate:a", 0, 3)
		$Selection/select_menu.modulate.a = 1
		$Selection/main_menu.modulate.a = 0
		stateShit = 2
		trans = false
	
	match MainScript.progress:
		0:
			$Selection/select_menu/youButton.play("select")
			$Selection/select_menu/peaButton.play("locked")
			$Selection/select_menu/romButton.play("locked")
			curSelected = 0
		1:
			$Selection/select_menu/youButton.play("dead")
			$Selection/select_menu/peaButton.play("select")
			$Selection/select_menu/romButton.play("locked")
			curSelected = 1
		2:
			$Selection/select_menu/youButton.play("dead")
			$Selection/select_menu/peaButton.play("dead")
			$Selection/select_menu/romButton.play("select")
			curSelected = 2
		3:
			$Selection/select_menu/youButton.play("dead")
			$Selection/select_menu/peaButton.play("dead")
			$Selection/select_menu/romButton.play("dead")
			$Selection/select_menu/no.text = ''
			stateShit = 3
			$mainMenu.pitch_scale = 0.6
			await get_tree().create_timer(3).timeout
			$perec.play()
			await get_tree().create_timer(20).timeout
			MainScript.progress = 4
			MainScript.give_access()
			MainScript.save_data()
			var tween3 = get_tree().create_tween()
			tween3.tween_property($flash2, "self_modulate:a", 1, 6)
			var tween3mus = get_tree().create_tween()
			tween3mus.tween_property($mainMenu, "volume_db", -80, 6)
			await get_tree().create_timer(12).timeout
			get_tree().quit()
		4:
			$Selection/select_menu/youButton.play("select")
			$Selection/select_menu/peaButton.play("dead")
			$Selection/select_menu/romButton.play("dead")
			
			$Selection/select_menu/arrow_1.visible = true
			$Selection/select_menu/arrow_2.visible = true
			$Selection/select_menu/no.text = 'Use WASD/ARROW keys to select\nPress ENTER to Start'
			curSelected = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	$Main/logo.position.y = start_y + sin(TAU * Time.get_ticks_msec() / 1000.0 / sway_duration) * sway_distance
	$Main/head.position.y = start_Head + sin(TAU * Time.get_ticks_msec() / 1000.0 / 5) * sway_distance
	$Main/hand.position.y = start_yH1 + sin(TAU * Time.get_ticks_msec() / 1000.0 / 10) * 10
	$Main/hand2.position.y = start_yH2 + sin(TAU * Time.get_ticks_msec() / 1000.0 / 10) * 10
	$Selection/select_menu/text.position.y = start_victim + sin(TAU * Time.get_ticks_msec() / 1000.0 / 10) * 10
	$Selection/main_menu/Head.position.y = start_hui + sin(TAU * Time.get_ticks_msec() / 1000.0 / 6) * 10
	$Selection/main_menu/funny_flicker.position.y = start_hui + sin(TAU * Time.get_ticks_msec() / 1000.0 / 6) * 10
	
	if randi_range(0, 6666) == 1:
		$Selection/main_menu/funny_flicker.visible = true
		$Timer.stop()
		$Timer.start()
		
		
	if Input.is_action_just_pressed("ui_left") and not trans and stateShit == 2 and MainScript.progress == 4:
		curSelected -= 1
		$select.play()
		
		if curSelected == -1:
			curSelected = 2
			
		match(curSelected):
			0:
				$Selection/select_menu/youButton.play("select")
				$Selection/select_menu/peaButton.play("dead")
				$Selection/select_menu/romButton.play("dead")
			1:
				$Selection/select_menu/youButton.play("dead")
				$Selection/select_menu/peaButton.play("select")
				$Selection/select_menu/romButton.play("dead")
			2:
				$Selection/select_menu/youButton.play("dead")
				$Selection/select_menu/peaButton.play("dead")
				$Selection/select_menu/romButton.play("select")
			
	if Input.is_action_just_pressed("ui_right") and not trans and stateShit == 2 and MainScript.progress == 4:
		curSelected += 1
		$select.play()
		
		if curSelected == 3:
			curSelected = 0
			
		match(curSelected):
			0:
				$Selection/select_menu/youButton.play("select")
				$Selection/select_menu/peaButton.play("dead")
				$Selection/select_menu/romButton.play("dead")
			1:
				$Selection/select_menu/youButton.play("dead")
				$Selection/select_menu/peaButton.play("select")
				$Selection/select_menu/romButton.play("dead")
			2:
				$Selection/select_menu/youButton.play("dead")
				$Selection/select_menu/peaButton.play("dead")
				$Selection/select_menu/romButton.play("select")
		
	if Input.is_action_just_pressed("escape") and not trans and stateShit == 2:
		trans = true
		$trans.play()

		var tweengay = get_tree().create_tween()
		tweengay.tween_property($Selection/select_menu, "modulate:a", 0, 1)
		await get_tree().create_timer(1).timeout
		var tweengay2 = get_tree().create_tween()
		tweengay2.tween_property($Selection/main_menu, "modulate:a", 1, 1)
		$Selection/main_menu/start.focus_mode = FOCUS_ALL
		$Selection/main_menu/options.focus_mode = FOCUS_ALL
		$Selection/main_menu/quit.focus_mode = FOCUS_ALL
		$Selection/main_menu/start.grab_focus()
		$Selection/main_menu/quit.modulate.a = 0.6
		$Selection/main_menu/options.modulate.a = 0.6
		$Selection/main_menu/start.modulate.a = 1
		await get_tree().create_timer(1).timeout
		stateShit = 1
		trans = false
		
	if stateShit == 2:
		if Input.is_action_just_pressed("ui_accept") and not trans:
			trans = true
			stateShit = 3
			var no = get_tree().create_tween()
			no.tween_property($mainMenu, "pitch_scale", 0.01, 10)
			$accept.play()
			var tween = get_tree().create_tween()
			tween.tween_property($flash, "self_modulate:a", 1, 0.3)
			await get_tree().create_timer(0.3).timeout
			$Selection.visible = false
			$Main.visible = false
			var tween2 = get_tree().create_tween()
			tween2.tween_property($flash, "self_modulate:a", 0, 3)
			await get_tree().create_timer(3).timeout
			
			match curSelected:
				0:
					$Label.text = "Это был обычный день, все было хорошо. "+username+" вернулся домой, зашел в интернет, и увидел ужасную новость..."
				1:
					$Label.text = "КейтВТФ занимался написанием сценария для бп реплантеда. Но пока он занимался этим, кто то решил заглянуть к нему в гости..."
				2:
					$Label.text = "Рома проснулся в неожиданное время и в неожиданном месте...\n\nПора узнать что тут происходит!"
					
			var end = get_tree().create_tween()
			end.tween_property($Label, "self_modulate:a", 1, 3)
			await get_tree().create_timer(6).timeout
			var end2 = get_tree().create_tween()
			end2.tween_property($Label, "self_modulate:a", 0, 3)
			await get_tree().create_timer(3).timeout
			match curSelected:
				0:
					get_tree().change_scene_to_file('res://level_1_save.tscn')
				1:
					get_tree().change_scene_to_file('res://level_2_save.tscn')
				2:
					get_tree().change_scene_to_file('res://level_3_save.tscn')

func _on_melt_nahui() -> void:
	$Main.visible = false
	$trans1.play()
	await get_tree().create_timer(5).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property($Selection/shit, "modulate:a", 0, 3)
	$Selection.visible = true
	$Selection/main_menu/start.grab_focus()
	await get_tree().create_timer(3).timeout
	stateShit = 1
	
func glitch():
	await get_tree().create_timer(randf_range(0.6, 1)).timeout
	$Selection/main_menu/start.set_position(Vector2(randf_range(6, 26), randf_range(4, 34)))
	$Selection/main_menu/options.set_position(Vector2(randf_range(6, 26), randf_range(78, 98)))
	$Selection/main_menu/quit.set_position(Vector2(randf_range(-42, -22), randf_range(142, 162)))
	glitch()

func _on_options_focus_entered() -> void:
	if stateShit == 2: return
	$select.play()
	$Selection/main_menu/options.modulate.a = 1
	


func _on_options_focus_exited() -> void:
	if stateShit == 2: return
	$Selection/main_menu/options.modulate.a = 0.6


func _on_start_focus_entered() -> void:
	if stateShit == 2: return
	$select.play()
	$Selection/main_menu/start.modulate.a = 1


func _on_start_focus_exited() -> void:
	$Selection/main_menu/start.modulate.a = 0.6


func _on_quit_focus_entered() -> void:
	if stateShit == 2: return
	$select.play()
	$Selection/main_menu/quit.modulate.a = 1


func _on_quit_focus_exited() -> void:
	if stateShit == 2: return
	
	$Selection/main_menu/quit.modulate.a = 0.6


func _on_start_pressed() -> void:
	if stateShit == 2: return
	
	$trans.play()
	$Selection/main_menu/quit.focus_mode = FOCUS_NONE
	$Selection/main_menu/start.release_focus()
	var tweengay = get_tree().create_tween()
	tweengay.tween_property($Selection/main_menu, "modulate:a", 0, 1)
	await get_tree().create_timer(1).timeout
	var tweengay2 = get_tree().create_tween()
	tweengay2.tween_property($Selection/select_menu, "modulate:a", 1, 1)
	await get_tree().create_timer(1).timeout
	stateShit = 2
	trans = false


func _on_timer_timeout() -> void:
	$Selection/main_menu/funny_flicker.visible = false


func _on_options_pressed() -> void:
	if stateShit == 2: return
	$select.play()
	$Selection/main_menu/options.release_focus()
	$Selection/main_menu/quit.focus_mode = FOCUS_NONE
	$options.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_button_pressed() -> void:
	if stateShit == 2: return
	$Selection/main_menu/options.grab_focus()
	$Selection/main_menu/quit.focus_mode = FOCUS_ALL
	$options.visible = false


func _on_quit_pressed() -> void:
	if stateShit == 2: return
	$trans.play()
	$Selection/main_menu/quit.release_focus()
	$Selection/main_menu/quit.focus_mode = FOCUS_NONE
	var tween = get_tree().create_tween()
	tween.tween_property($Selection/shit, "modulate:a", 1, 3)
	await get_tree().create_timer(3).timeout
	get_tree().quit()
