extends AudioStreamPlayer


func _on_game_ended() -> void:
	stop()


func _ready() -> void:
	Global.bgm = self


func _on_game_started() -> void:
	play()
