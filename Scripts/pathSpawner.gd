extends Node2D

@onready var enemyTimer: Timer = $enemyTimer
@onready var level: Node2D = $".."
@export var path = preload("res://Scenes/path1.tscn")
@onready var levelEnemies = level.totalEnemies

func _ready():
	self.position = get_parent().pathSpawnPos
	enemyTimer.start(GlobalScript.enemyDelay)



func _on_enemy_timer_timeout() -> void:
		
	if levelEnemies >= 0:
		var temp = path.instantiate()
		add_child(temp)
		levelEnemies -= 1
	else:
		enemyTimer.autostart = false
		enemyTimer.stop()
