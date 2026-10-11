extends Sprite3D

var pulledOut:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await TimerRoot.delay(1)
	pulledOut = true
	await TimerRoot.delay(6)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !pulledOut:
		global_position = lerp(self.global_position, get_parent().get_node("player").global_position, 0.01)
	else:
		position+=transform.basis * Vector3(0,0, -4) * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		body.hurtPain(25)
		queue_free()
