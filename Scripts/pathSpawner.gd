extends Node2D

@onready var enemyTimer: Timer = $enemyTimer
@onready var level: Node2D = $".."
@export var path = preload("res://Scenes/path1.tscn")
@onready var levelEnemies = level.totalEnemies

func _ready():
	var offsetDelay = 0
	for sibling in get_parent().get_child_count():
		if get_parent().get_child(sibling).is_in_group("pathSpawner") and get_parent().get_child(sibling).get_index() > self.get_index():
			offsetDelay += .5
	enemyTimer.start(GlobalScript.enemyDelay + offsetDelay)
	enemyTimer.autostart = false

func _process(delta: float) -> void:
	if GlobalScript.hasWon:
		if !has_node("waveTimer"):
			
func _on_enemy_timer_timeout() -> void:
	enemyTimer.start(GlobalScript.enemyDelay)
	enemyTimer.autostart = true
	if levelEnemies >= 0 or GlobalScript.hasWon:
		var temp = path.instantiate()
		add_child(temp)
		levelEnemies -= 1
	else:
		enemyTimer.autostart = false
		enemyTimer.stop()
