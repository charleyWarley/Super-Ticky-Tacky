extends AudioStreamPlayer


func _on_game_ended() -> void:
	stop()


func _ready() -> void:
	volume_db = -80
	Global.bgm = self


func fade_in() -> void:
	var interval = sqrt(volume_db) if sign(volume_db) == 1 else sqrt(-volume_db)
	if volume_db < 7:
		if volume_db + interval > 7: volume_db = 7
		else: volume_db += interval
	if volume_db == 7: return
	await get_tree().create_timer(0.08).timeout
	fade_in()


func _on_game_started() -> void:
	await get_tree().create_timer(2).timeout
	play()
	fade_in()
	
