extends Button

var is_muted = false

func _on_pressed() -> void:
	get_tree().reload_current_scene()
