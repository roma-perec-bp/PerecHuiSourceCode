extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_checkboxes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_vsync_check_toggled(toggled_on: bool) -> void:
	MainScript.vsync = toggled_on
	MainScript.save_data()
	MainScript.reload_setting(1)


func _on_full_check_toggled(toggled_on: bool) -> void:
	MainScript.fullScreen = toggled_on
	MainScript.save_data()
	MainScript.reload_setting(0)


func _on_flash_check_toggled(toggled_on: bool) -> void:
	MainScript.lights = toggled_on
	MainScript.save_data()


func _on_sense_slider_value_changed(value: float) -> void:
	MainScript.mouseSense = value
	MainScript.save_data()

func reload_checkboxes():
	$vsync_check.button_pressed = MainScript.vsync
	$flash_check.button_pressed = MainScript.lights
	$full_check.button_pressed = MainScript.fullScreen
	
	$sense_slider.value = MainScript.mouseSense
	
	$music_slider.value = MainScript.music_volume
	$sound_slider.value = MainScript.sfx_volume


func _on_music_slider_value_changed(value: float) -> void:
	MainScript.music_volume = value
	MainScript.save_data()
	MainScript.reload_setting(2)


func _on_sound_slider_value_changed(value: float) -> void:
	MainScript.sfx_volume = value
	MainScript.save_data()
	MainScript.reload_setting(3)
