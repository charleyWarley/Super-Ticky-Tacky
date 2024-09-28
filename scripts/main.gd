extends Control

@onready var canvas_layer := $CanvasLayer
@onready var pause_menu := preload("res://scenes/pause_menu.tscn")


func _ready():
	get_tree().set_pause(false)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().set_pause(!get_tree().paused)
		if get_tree().is_paused():
			var new_menu := pause_menu.instantiate()
			canvas_layer.add_child(new_menu)
