extends Label

func _process(_delta: float) -> void:
	if Global.current_player == 1 and text == "player two":
		text = "player one"
	elif Global.current_player == 2 and text == "player one":
		text = "player two"
