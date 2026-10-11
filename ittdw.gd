extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _activate_text():
	$sound.play()
	$text.visible = true
	await get_tree().create_timer(0.25).timeout
	var tweenFunny = create_tween()	
	tweenFunny.set_ease(Tween.EASE_OUT)
	tweenFunny.set_trans(Tween.TRANS_QUAD)
	tweenFunny.tween_property($text, "position:y", 8.389, 1)
	await get_tree().create_timer(3).timeout
	$text.visible = false
