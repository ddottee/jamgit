extends Node2D

@onready var enemyTimer: Timer = $enemyTimer

@export var spawnTime := 1.0
@export var path = preload("res://Scenes/path1.tscn")


func _ready():
	self.position = get_parent().pathSpawnPos
	enemyTimer.start(spawnTime)

func _on_enemy_timer_timeout() -> void:
	var temp = path.instantiate()
	add_child(temp)
