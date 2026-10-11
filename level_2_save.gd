extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if MainScript.lvl2 == 0:
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_file('res://level2-1.tscn')
	else:
		$start.grab_focus()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	match (MainScript.lvl2):
		1:
			get_tree().change_scene_to_file('res://level2-2.tscn')


func _on_start_2_pressed() -> void:
	MainScript.lvl2 = 0
	MainScript.save_data()
	get_tree().change_scene_to_file('res://level2-1.tscn')
