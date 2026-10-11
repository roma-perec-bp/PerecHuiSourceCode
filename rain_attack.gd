extends Sprite3D

var bobomb=load("res://bomb.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("flash")
	await TimerRoot.delay(2)
	var nuke = bobomb.instantiate()
	nuke.position = $Node3D.global_position
	nuke.transform.basis = $Node3D.global_transform.basis
	get_parent().add_child(nuke)
	
	await TimerRoot.delay(0.7)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "hui":
		body.queue_free()
		queue_free()
