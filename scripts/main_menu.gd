extends Control
class_name MainMenu

signal game_started


func _on_multi_button_pressed() -> void:
	Global.player_count = 2
	start_game()
	

func _on_single_button_pressed() -> void:
	Global.player_count = 1
	start_game()

func start_game() -> void:
	game_started.emit()
	queue_free()
