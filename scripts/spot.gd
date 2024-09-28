extends Panel
class_name Spot

signal turn_taken(active_spot: Spot, spot_owner: int)
signal spot_name_set(named_spot: Spot)

var this_game : Game
var spot_owner : int = -1
var can_click = false
@onready var sfx := $sfx


func _on_mouse_entered() -> void:
	if Global.player_count == 1 and Global.current_player == 2: return
	if !this_game:
		push_warning(name, " has no game associated")
		return
	if !this_game.is_playable: return
	if spot_owner == -1: 
		modulate = Color.LIGHT_GRAY
		can_click = true


func _on_mouse_exited() -> void:
	if Global.player_count == 1 and Global.current_player == 2: return
	if !this_game:
		push_warning(name, " has no game associated")
		return
	if !this_game.is_playable: return
	if can_click: can_click = false
	if spot_owner == -1: modulate = Color.WHITE


func _ready() -> void:
	set_new_name()
	spot_name_set.emit(self)


func _process(_delta: float) -> void:
	if !can_click: return
	if Input.is_action_just_pressed("left_click"):
		set_spot_owner()


func set_spot_owner() -> void:
	var owner_color:= get_owner_color()
	modulate = owner_color
	var new_label := Label.new()
	new_label.text = "X" if Global.current_player == 1 else "O"
	add_child(new_label)
	new_label.position = Vector2(
		size.x/2 - new_label.size.x/2, 
		size.y/2 - new_label.size.y/2)
	can_click = false
	spot_owner = Global.current_player
	sfx.pitch_scale = 1
	sfx.play()
	turn_taken.emit(self, spot_owner)
	Global.change_player()


func set_auto_owner():
	randomize()
	await get_tree().create_timer(randf_range(1.0, 1.8)).timeout
	var owner_color:= Color.AQUAMARINE
	modulate = owner_color
	var new_label := Label.new()
	new_label.text = "O"
	add_child(new_label)
	new_label.position = Vector2(
		size.x/2 - new_label.size.x/2, 
		size.y/2 - new_label.size.y/2)
	can_click = false
	spot_owner = Global.current_player
	sfx.pitch_scale = 1.8
	sfx.play()
	turn_taken.emit(self, spot_owner)
	Global.current_player = 1


func set_new_name() -> void:
	var parent = get_parent()
	var offset = 0
	if parent.name.begins_with("top"):
		return
	else:
		offset = 3 if parent.name.begins_with("middle") else 6
		name = get_name_string(offset)


func get_name_string(offset: int) -> String:
	return "game_spot" + str(int(name.trim_prefix("game_spot")) + offset)


func get_owner_color() -> Color:
	if Global.current_player == 1:
		return Color.DARK_ORANGE
	else:
		return Color.AQUAMARINE
