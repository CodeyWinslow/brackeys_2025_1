extends Node

enum GameFlowState
{
	SHELL,
	INGAME
}

var game_flow_state : GameFlowState = GameFlowState.SHELL

# Game Flow API

func start_game():
	if game_flow_state != GameFlowState.SHELL:
		printerr('could not start game. application is not in menus')
		return
	
	print('starting game!')
	
func quit_to_menu():
	if game_flow_state != GameFlowState.INGAME:
		printerr('can not quit to menus when out of game')
		return
	
	print('quitting to menu')
