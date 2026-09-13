extends CanvasLayer

@onready var healthLabel : Label = %playerHealth
@onready var cashLabel: Label = %playerCash
@onready var pausePlayButton: TextureButton = %pausePlay
@onready var speedupButton: TextureButton = %speedup
@onready var speedLabel: Label = %speedLabel
@onready var pauseLabel: Label = %pauseLabel
@onready var shopRect: TextureRect = $shopRect
@onready var shopButton: TextureButton = $shopRect/shopButton
@onready var shopMarker: Control = $shopMarker
@onready var defaultButton: Button = %defaultButton
@onready var athleteButton: Button = %athleteButton
@onready var bullyButton: Button = %bullyButton
@onready var razorbladeButton: Button = %razorbladeButton
@onready var richButton: Button = %richButton
@onready var stinkyButton: Button = %stinkyButton

@onready var levelRoot: Node2D = get_node("../level")
@onready var backgroundTiles: TileMapLayer = get_node("../level/backgroundTiles")
@onready var pathTiles: TileMapLayer = get_node("../level/pathTiles")
@onready var decorationTiles: TileMapLayer = get_node("../level/decorationTiles")


var tween
var speedup := 1.0


func _ready() -> void:

	SignalBus.damagePlayer.connect(updateHealth)
	SignalBus.updateCash.connect(updateCash)
	updateHealth()
	updateCash()
	speedLabel.text = str(int(Engine.get_time_scale())) + "x"
	defaultButton.pressed.connect(setTowerPreview.bind("default"))
	athleteButton.pressed.connect(setTowerPreview.bind("athlete"))
	bullyButton.pressed.connect(setTowerPreview.bind("bully"))
	razorbladeButton.pressed.connect(setTowerPreview.bind("razorblade"))
	richButton.pressed.connect(setTowerPreview.bind("rich"))
	stinkyButton.pressed.connect(setTowerPreview.bind("stinky"))


func setTowerPreview(towerType) -> void:
	if GlobalScript.playerCash < 5 or GlobalScript.towerNumber >= 10:
		return
	if has_node("towerPreview"):
		get_node("towerPreview").queue_free()

	var mousePos = get_viewport().get_mouse_position()
	var temp = load("res://Scenes/towers/" + towerType + ".tscn")
	var drag = temp.instantiate()

	drag.set_name("dragTower")
	drag.modulate = Color("ForestGreen", .5)

	# disable all gameplay behavior while it's just a preview
	drag.set_process(false)
	drag.set_physics_process(false)
	for child in drag.find_children("*", "Area2D", true, false):
		child.monitoring = false
		child.monitorable = false
	for child in drag.find_children("*", "Timer", true, false):
		child.stop()

	var rangeTexture = Sprite2D.new()
	var texture = load("res://Assets/Sprites/Towers/towerAssets/range.png")

	var rangeScale = drag.targetRange / 600.0

	rangeTexture.scale = Vector2(rangeScale, rangeScale)
	rangeTexture.texture = texture
	rangeTexture.position = Vector2(32, 32)
	rangeTexture.modulate = Color("ForestGreen")

	var control = Control.new()
	control.add_child(drag, true)
	control.add_child(rangeTexture, true)
	control.position = mousePos
	control.set_name("towerPreview")
	control.set_meta("towerType", towerType)
	add_child(control, true)


func _process(delta: float) -> void:
	shopButton.global_position = shopRect.global_position + Vector2(-28, 0)

	if has_node("towerPreview"):
		var preview = get_node("towerPreview")
		preview.position = get_viewport().get_mouse_position()

		var drag = preview.get_node("dragTower")
		if isValidPlacement(preview.position):
			drag.modulate = Color("ForestGreen", .5)
		else:
			drag.modulate = Color("Red", .5)


func _unhandled_input(event: InputEvent) -> void:
	if not has_node("towerPreview"):
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			tryPlaceTower()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			get_node("towerPreview").queue_free()


func tryPlaceTower() -> void:
	var preview = get_node("towerPreview")
	var placePos = preview.position

	if not isValidPlacement(placePos):
		return # invalid spot, keep dragging, don't spend money

	GlobalScript.playerCash -= 5
	SignalBus.updateCash.emit()

	var towerType = preview.get_meta("towerType")
	var temp = load("res://Scenes/towers/" + towerType + ".tscn")
	var realTower = temp.instantiate()
	levelRoot.add_child(realTower)
	realTower.global_position = placePos
	GlobalScript.towerNumber += 1
	preview.queue_free()


func isValidPlacement(pos: Vector2) -> bool:
	if backgroundTiles == null:
		return true # no tilemap assigned, don't block placement

	var onBackground = backgroundTiles.get_cell_source_id(
		backgroundTiles.local_to_map(backgroundTiles.to_local(pos))
	) != -1

	var onPath = false
	if pathTiles:
		onPath = pathTiles.get_cell_source_id(
			pathTiles.local_to_map(pathTiles.to_local(pos))
		) != -1

	var onDecoration = false
	if decorationTiles:
		onDecoration = decorationTiles.get_cell_source_id(
			decorationTiles.local_to_map(decorationTiles.to_local(pos))
		) != -1

	return onBackground and not onPath and not onDecoration


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


func _on_shop_button_pressed() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	if shopButton.is_pressed():
		tween.tween_property(shopRect, "global_position", shopMarker.global_position, .2)
	else:
		tween.tween_property(shopRect, "global_position", Vector2(shopMarker.global_position.x - 350, shopMarker.global_position.y), .2)
