extends HBoxContainer
class_name BoardRow

signal game_closed(closed_game: Game)
signal game_rejected(rejected_game: Game)
signal turn_taken(active_spot: Spot)
signal game_ready(ready_game: Game)


func _on_game_closed(closed_game: Game) -> void:
	game_closed.emit(closed_game)

func _on_game_rejected() -> void:
	game_rejected.emit()

func _on_turn_taken(spot: Spot) -> void:
	turn_taken.emit(spot)

func _on_game_ready(ready_game: Game) -> void:
	game_ready.emit(ready_game)
