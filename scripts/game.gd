extends VBoxContainer
class_name Game

signal game_closed(closed_game: Game)
signal turn_taken(active_spot: Spot)
signal game_rejected()
signal game_ready(ready_game: Game)

var owned_spots := []
var spots := []
var spot_owners := []
var game_winner : int = -1
var is_playable := true
@onready var sfx := $sfx


func _on_turn_taken(active_spot: Spot, spot_owner: int) -> void:
	var spot_number : int = int(active_spot.name.trim_prefix("spot"))
	spot_owners.append([spot_number, spot_owner])
	owned_spots.append(active_spot)
	if spot_owners.size() > 2: check_winner()
	is_playable = false
	Global.active_games = []
	Global.has_auto_picker = false
	turn_taken.emit(active_spot)
	modulate = Color.GRAY


func _on_spot_name_set(named_spot: Spot) -> void:
	named_spot.this_game = self
	spots.append(named_spot)
	if spots.size() == 9:
		game_ready.emit(self)


func _ready() -> void:
	modulate = Color.WHITE
	set_new_name()


func set_new_name() -> void:
	var parent = get_parent()
	var offset = 0
	if parent.name.begins_with("top"):
		return
	else:
		offset = 3 if parent.name.begins_with("middle") else 6
		name = get_name_string(offset)


func get_name_string(offset: int) -> String:
	return "game" + str(int(name.trim_prefix("game")) + offset)


func check_winner():
	var player1_spots := []
	var player2_spots := []
	for spot_owner in spot_owners:
		if spot_owner[1] == 1:
			player1_spots.append(spot_owner[0])
		else:
			player2_spots.append(spot_owner[0])
	var _spots = [player1_spots, player2_spots]
	for player in _spots:
		var _winner = check_spots(player, _spots)
		if _winner != 0:
			declare_winner(_winner)
			break
		else:
			if spot_owners.size() == 9:
				declare_winner(0)
				break


func check_spots(player, _spots) -> int:
	for spot in Global.winning_numbers:
		if player.has(spot[0]) and player.has(spot[1]) and player.has(spot[2]):
			var winner = 1 if player == _spots[0] else 2
			return winner
	return 0


func declare_winner(winner : int) -> void:
	game_winner = winner
	is_playable = false
	var tween := get_tree().create_tween()
	var win_color := get_win_color(winner)
	tween.tween_property(self, "modulate", win_color, 1)
	tween.play()
	sfx.play()
	replace_spot_labels(winner)
	game_closed.emit(self)


func get_win_color(winner) -> Color:
	if winner == 0:
		return Color.RED
	elif winner == 1:
		return Color.DARK_ORANGE
	else:
		return Color.AQUAMARINE


func replace_spot_labels(winner: int):
	await get_tree().create_timer(0.5).timeout
	for spot in spots:
		if spot.get_child_count() > 1:
			spot.get_child(1).queue_free()
	var new_label : String
	match winner:
		0: new_label = "C"
		1: new_label = "X"
		2: new_label = "O"
	set_labels(new_label)


func set_labels(new_label: String):
	for spot in spots:
		var winner_label = Label.new()
		winner_label.text = new_label
		spot.add_child(winner_label)
		winner_label.position = Vector2(
			spot.size.x/2 - winner_label.size.x/2, 
			spot.size.y/2 - winner_label.size.y/2)
		await get_tree().create_timer(0.1).timeout


func make_unplayable() -> void:
	modulate = Color.GRAY
	is_playable = false


func make_playable() -> void:
	if game_winner != -1:
		game_rejected.emit()
		return
	Global.active_games.append(self)
	is_playable = true
	modulate = Color.DIM_GRAY
	await get_tree().create_timer(0.1).timeout
	modulate = Color.GRAY
	await get_tree().create_timer(0.1).timeout
	modulate = Color.DIM_GRAY
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if Global.player_count == 1 and Global.current_player == 2 and !Global.is_game_over:
		take_auto_turn()


func take_auto_turn() -> void:
	if Global.active_games.size() > 1:
		Global.pick_active_game()
		await Global.active_game_set
		if !Global.active_games.has(self): return
	randomize()
	var random_index := randi_range(0, 8)
	if owned_spots.has(spots[random_index]):
		print("spot not available")
		take_auto_turn()
		return
	spots[random_index].set_auto_owner()
