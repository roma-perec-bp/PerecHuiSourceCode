extends Control

var trans:bool = false
var canUnpause:bool = false
var randText:Array[String] = [
	"Paused...",
	"Tired already?",
	"Games are never over",
	"Rest in Piece",
	"Go get some rest",
	"I'll wait...",
	"Stopped",
	"Are you scared?"
]

# Called when the node enters the scene tree for the first time.
func pause():
	$Label.text = randText[randi_range(0, 7)]
	$sound.play()

func _on_resume_pressed() -> void:
	if trans: return
	self.visible = false
	get_tree().paused = false
	TimerRoot.set_paused(false)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().create_timer(0.1).timeout
	canUnpause = true


func _on_options_pressed() -> void:
	if trans: return
	$options_menu.visible = true


func _on_exit_pressed() -> void:
	if trans: return
	trans = true
	$ColorRect2.self_modulate.a = 0.2
	await get_tree().create_timer(0.6).timeout
	$ColorRect2.self_modulate.a = 0.4
	await get_tree().create_timer(0.6).timeout
	$ColorRect2.self_modulate.a = 0.6
	await get_tree().create_timer(0.6).timeout
	$ColorRect2.self_modulate.a = 0.8
	await get_tree().create_timer(0.6).timeout
	$ColorRect2.self_modulate.a = 1
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	TimerRoot.set_paused(false)
	MainScript.backFromLevel = true
	get_tree().change_scene_to_file('res://mainMenu.tscn')


func _on_button_pressed() -> void:
	$options_menu.visible = false
