extends HBoxContainer
class_name GameRow

signal turn_taken (active_spot: Spot, spot_owner: int)
signal spot_name_set(named_spot: Spot)

func _on_turn_taken(spot: Spot, spot_owner: int) -> void:
	turn_taken.emit(spot, spot_owner)

func _on_spot_name_set(named_spot: Spot) -> void:
	spot_name_set.emit(named_spot)
