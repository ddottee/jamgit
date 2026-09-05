extends Node


enum gameStates {MENU, PAUSE, PLAY, SHOP, WIN, LOSE}


@export_group("Player Data")

@export var playerHealth = 10
@export var playerCash = 10


@export_group("Game Data")

@export var gameState := gameStates.MENU
@export var speedMult := 1.0


@export_group("Level Data")

@export var enemyDelay := 1.0



func _process(delta: float) -> void:
	pass


func takeDamage(damage):
	playerHealth -= damage
	if playerHealth <= 0:
		playerLose()


func pauseGame():
	pass


func playerLose():
	SignalBus.playerLose
	
func playerWin():
	SignalBus.playerWin
	

	
