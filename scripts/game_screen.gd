extends Control

signal game_ended

func _on_game_ended() -> void:
	game_ended.emit()

func _ready() -> void:
	game_ended.connect(Global.bgm._on_game_ended)
