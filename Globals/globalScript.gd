extends Node


enum gameStates {MENU, PAUSE, PLAY, SHOP, WIN, LOSE}


@export_group("Player Data")

@export var playerHealth = 10
@export var playerCash = 10


@export_group("Game Data")

@export var gameState := gameStates.MENU
@export var speedMult := 1.0
@export var building := false
@export var musicVol = 1.0
@export var sfxVol = 1.0
@export var towerNumber : int = 0

@export_group("Level Data")

@export var enemyDelay := 1.0

@export var enemies = 20

var hasWon = false
func _process(delta: float) -> void:
	AudioServer.set_bus_volume_linear(0, musicVol)
	if enemies <= 0 and !hasWon:
		playerWin()



	
		



func takeDamage(damage):
	SignalBus.damagePlayer.emit()
	playerHealth -= damage
	if playerHealth <= 0:
		playerLose()

func cancelBuildMode():
	pass

func pauseGame():
	pass


func playerLose():
	SignalBus.playerLose.emit()
	GlobalScript.gameState = GlobalScript.gameStates.LOSE
	get_tree().change_scene_to_file("res://Scenes/lose")
	get_tree().paused = true
	
	
func playerWin():
	SignalBus.playerWin.emit()
	hasWon = true
	GlobalScript.gameState = GlobalScript.gameStates.PAUSE
	var temp = load("res://Scenes/win.tscn")
	get_tree().add_child(temp)
	get_tree().paused = true

	
