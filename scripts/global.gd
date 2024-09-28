extends Node

signal active_game_set

var winning_numbers := [
	[1, 2, 3],
	[4, 5, 6],
	[7, 8, 9],
	[1, 4, 7],
	[2, 5, 8],
	[3, 6, 9],
	[1, 5, 9],
	[3, 5, 7]
	]
var active_games := []
var current_player : int = 1
var player_count : int = 1
var is_game_over := false
var has_auto_picker := false

func change_player() -> void:
	if current_player == -1: current_player = 1
	else: current_player = 1 if current_player == 2 else 2

func pick_active_game():
	randomize()
	await get_tree().create_timer(randf_range(0.0, 0.3)).timeout
	if has_auto_picker == true: return
	has_auto_picker = true
	print("auto picking game")
	randomize()
	var random_index := randi_range(0, active_games.size() - 1)
	var active_game = active_games[random_index]
	active_games = []
	active_games.append(active_game)
	active_game_set.emit()
