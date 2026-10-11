extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if MainScript.lvl3 == 0:
		#await get_tree().create_timer(0.1).timeout
		#get_tree().change_scene_to_file('res://level3-1.tscn')
	#else:
		$start.grab_focus()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 1, 1)




func _on_start_pressed() -> void:
	match (MainScript.lvl3):
		1:
			get_tree().change_scene_to_file('res://level3-2.tscn')
		2:
			get_tree().change_scene_to_file('res://level3-3.tscn')
		3:
			get_tree().change_scene_to_file('res://level3-4.tscn')


func _on_start_2_pressed() -> void:
	MainScript.lvl3 = 0
	MainScript.save_data()
	get_tree().change_scene_to_file('res://level3-1.tscn')
