extends CanvasLayer

@onready var healthLabel : Label = %playerHealth
@onready var cashLabel: Label = %playerCash
@onready var pausePlayButton: TextureButton = %pausePlay
@onready var speedupButton: TextureButton = %speedup
@onready var speedLabel: Label = %speedLabel
@onready var pauseLabel: Label = %pauseLabel

var speedup := 1.0

func _ready() -> void:
	SignalBus.damagePlayer.connect(updateHealth)
	SignalBus.updateCash.connect(updateCash)
	updateHealth()
	updateCash()
	speedLabel.text = str(int(Engine.get_time_scale())) + "x"

func setTowerPreview(towerType, mousePos) -> void:
	var temp = load("res://Scenes/towers/" + towerType + ".tscn")
	var drag = temp.instantiate()
	
	drag.set_name("dragTower")
	drag.modulate = Color("ForestGreen")
	
	var rangeTexture = Sprite2D.new()
	var texture = load("res://Assets/Sprites/Towers/range.svg")
	var rangeScale = drag.range() / 600.0
	
	rangeTexture.scale = Vector2(rangeScale, rangeScale)
	rangeTexture.texture = texture
	rangeTexture.position = Vector2(32,32)
	rangeTexture.modulate = Color("ForestGreen")
	
	var control = Control.new()
	control.add_child(drag, true)
	control.add_child(rangeTexture, true)
	control.position = mousePos
	control.set_name("towerPreview")
	add_child(control, true)
	move_child(get_node("towerPreview"), 0)
	
func updatePreview(newPos, color) -> void:
	get_node("towerPreview").position = newPos
	if get_node("towerPreview/drag").modulate != Color(color):
		get_node("towerPreview/drag").modulate = Color(color)
		get_node("towerPreview/Sprite2D").modulate = Color(color)
	
	
#
# game control
#
	
func updateHealth() -> void:
	var health = GlobalScript.playerHealth
	print("health")
	if health <= 0:
		healthLabel.text = "0"
	else:
		healthLabel.text = str(health)
	if health >= 7:
		healthLabel.self_modulate = Color("PaleGreen")
	elif health >= 4:
		healthLabel.self_modulate = Color("DarkOrange")
	else:
		healthLabel.self_modulate = Color("Red")

func updateCash() -> void:
	var cash = GlobalScript.playerCash
	print("cash")
	cashLabel.text = str(cash)
	
	

func togglePause() -> void:
	if GlobalScript.gameState == GlobalScript.gameStates.PAUSE:
		GlobalScript.gameState = GlobalScript.gameStates.PLAY
		get_tree().paused = false
		pauseLabel.hide()
	else:
		GlobalScript.gameState = GlobalScript.gameStates.PAUSE
		get_tree().paused = true
		pauseLabel.show()


func speedUp() -> void:
	if GlobalScript.building:
		GlobalScript.cancelBuildMode()
	
	if Engine.get_time_scale() >= 4.0:
		Engine.set_time_scale(1.0)
	else:
		Engine.set_time_scale(Engine.get_time_scale() + 1)
	speedLabel.text = str(int(Engine.get_time_scale())) + "x"
	
