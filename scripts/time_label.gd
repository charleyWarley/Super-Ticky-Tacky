extends Label

func _ready() -> void:
	tick_seconds()


func tick_seconds() -> void:
	await get_tree().create_timer(1).timeout
	text = str(int(text) - 1)
	if int(text) > 0: tick_seconds()
