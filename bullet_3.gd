extends CharacterBody3D


const SPEED = 4

func _ready() -> void:
	await TimerRoot.delay(6)
	queue_free()
	
func _physics_process(delta: float) -> void:
	position+=transform.basis * Vector3(-1,0, -SPEED) * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		body.hurtPain(5)
		queue_free()
