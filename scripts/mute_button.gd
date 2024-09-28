extends Button

var is_muted := false


func _on_pressed() -> void:
	is_muted = !is_muted
	if is_muted: Global.bgm.stop() 
	else: Global.bgm.play()
