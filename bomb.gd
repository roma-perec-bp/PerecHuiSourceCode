extends Sprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await TimerRoot.delay(6)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position+=transform.basis * Vector3(0,0, -10) * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		body.hurtPain(10)
		queue_free()
