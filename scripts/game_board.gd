extends VBoxContainer

signal game_ended

var winner : int = -1
var closed_games := []
var game_winners := []
var games = []
@onready var sfx := $sfx


func _on_turn_taken(spot: Spot) -> void:
	for game in games:
		if !closed_games.has(game): game.make_unplayable()
	var spot_number = int(spot.name.trim_prefix("spot"))
	games[spot_number - 1].make_playable()


func _on_game_rejected() -> void:
	for game in games:
		if !closed_games.has(game): game.make_playable()


func _on_game_closed(closed_game: Game) -> void:
	game_winners.append([int(closed_game.name.trim_prefix("game")), closed_game.game_winner])
	closed_games.append(closed_game)
	if closed_games.size() > 2:
		check_winner()


func _on_game_ready(ready_game: Game) -> void:
	games.append(ready_game)


func check_winner():
	var player1_wins := []
	var player2_wins:= []
	for game_winner in game_winners:
		if game_winner[1] == 1:
			player1_wins.append(game_winner[0])
		elif game_winner[1] == 2:
			player2_wins.append(game_winner[0])
	var wins = [player1_wins, player2_wins]
	for player in wins:
		var _winner = check_wins(player, wins)
		if _winner != 0:
			declare_winner(_winner)
			break
		else:
			if game_winners.size() == 9:
				break_tie()
				break


func check_wins(player, wins) -> int:
	for game in Global.winning_numbers:
		if player.has(game[0]) and player.has(game[1]) and player.has(game[2]):
			var _winner = 1 if player == wins[0] else 2
			return _winner
	return 0


func declare_winner(_winner):
	winner = _winner
	for game in games:
		game.replace_spot_labels(winner)
	print("player", winner, " won the whole thing, guys!")
	Global.is_game_over = true
	game_ended.emit()
	sfx.play()

func break_tie():
	print("tie breaker")
	var player1_wins := 0
	var player2_wins := 0
	for game in closed_games:
		if game.game_winner == 1: player1_wins += 1
		if game.game_winner == 2: player2_wins += 1
	if player1_wins > player2_wins:
		print("player 1 is the winner")
	elif player2_wins > player1_wins:
		print("player 2 is the winner")
	else:
		print("NO WINNERRRRRRRRRRR!!!!!")
	Global.is_game_over = true
