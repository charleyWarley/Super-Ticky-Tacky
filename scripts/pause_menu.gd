extends Panel


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		queue_free()
