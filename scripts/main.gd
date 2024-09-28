extends Control

@onready var game_screen := preload("res://scenes/game_screen.tscn")



func _on_game_started() -> void:
	var new_game_screen = game_screen.instantiate()
	add_child(new_game_screen)
