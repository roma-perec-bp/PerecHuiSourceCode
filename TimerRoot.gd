extends Node

func delay(wait_time:float) -> void:
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = wait_time
	timer.one_shot = true
	timer.start()
	await timer.timeout
	timer.queue_free()

func set_paused(pause:bool) -> void:
	for node in get_children():
		var timer:Timer = node as Timer
		if !is_instance_valid(timer) or timer.is_queued_for_deletion():
			continue
			
		timer.paused = pause
