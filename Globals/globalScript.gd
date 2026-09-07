extends Node


enum gameStates {MENU, PAUSE, PLAY, SHOP, WIN, LOSE}


@export_group("Player Data")

@export var playerHealth = 10
@export var playerCash = 10


@export_group("Game Data")

@export var gameState := gameStates.MENU
@export var speedMult := 1.0

@export var musicVol = 1.0
@export var sfxVol = 1.0

@export_group("Level Data")

@export var enemyDelay := 1.0



func _process(delta: float) -> void:
	AudioServer.set_bus_volume_linear(0, musicVol)


func takeDamage(damage):
	playerHealth -= damage
	if playerHealth <= 0:
		playerLose()


func pauseGame():
	pass


func playerLose():
	SignalBus.playerLose.emit()
	GlobalScript.gameState = GlobalScript.gameStates.LOSE
	
func playerWin():
	SignalBus.playerWin.emit()
	GlobalScript.gameState = GlobalScript.gameStates.WIN

	
