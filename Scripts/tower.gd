extends StaticBody2D
class_name Tower

@onready var rangeCollider: CollisionShape2D = $rangeArea/rangeCollider
@onready var rangeArea: Area2D = $rangeArea
@onready var shotTimer: Timer = $shotTimer
@onready var aimMark: Marker2D = $aimMark
@onready var upgradeMenu: Panel = $upgradeMenu
@onready var towerSprite: Sprite2D = $towerSprite
@onready var targetTypeButton: TextureButton = $upgradeMenu/targetTypeButton
@onready var rangeDisplay: Sprite2D = $rangeDisplay
@onready var damageNum: Label = $upgradeMenu/damageNum
@onready var rangeNum: Label = $upgradeMenu/rangeNum
@onready var speedNum: Label = $upgradeMenu/speedNum
@onready var upgradeButton: TextureButton = $upgradeMenu/upgradeBar/upgradeButton
@onready var costLabel: Label = $upgradeMenu/upgradeBar/costLabel
@onready var nameplate: Label = $upgradeMenu/nameplate
@onready var tower_area: Area2D = $towerArea

@export var towerType = "Default"

enum targetTypes { FIRST, LAST }

@export_group("Stats")

@export var level := 1
@export var damage := 1
@export var bulletType: PackedScene = preload("res://Scenes/bullets/candy.tscn")
@export var targetRange := 100
@export var shotSpeed := 3

@export_group("Behavior")

@export var priorityTarget := targetTypes.FIRST
@export var canTargetAir := false

@export_group("Costs")

@export var cost := 5
@export var upgradeCost := 2

var currUpgradeCost := upgradeCost

var currTargets: Array[Node2D] = []
var curr: Node2D = null

var canShoot := false


func _ready() -> void:
	self.scale = Vector2(4,4)
	rangeArea.monitoring = true
	shotTimer.timeout.connect(_on_shot_timer_timeout)
	tower_area.input_event.connect(_on_tower_area_input_event)
	upgradeButton.pressed.connect(_on_upgrade_button_pressed)
	rangeArea.body_entered.connect(_on_range_area_body_entered)
	rangeArea.body_exited.connect(_on_range_area_body_exited)
	rangeDisplay.scale = 1/32 * Vector2(rangeCollider.shape.radius, rangeCollider.shape.radius)
	rangeDisplay.global_position = self.global_position
	rangeDisplay.hide()
	rangeCollider.shape.set_deferred("radius", targetRange)

	upgradeMenu.hide()

	shotTimer.wait_time = 3.0 / shotSpeed


func _process(delta: float) -> void:
	rangeDisplay.visible = upgradeMenu.visible
	if targetTypeButton.button_pressed:
		priorityTarget = targetTypes.LAST
	else:
		priorityTarget = targetTypes.FIRST
	find_target()

	if is_instance_valid(curr):

		var angle := rad_to_deg(get_angle_to(curr.global_position))

		if angle >= -45 and angle <= 45:
			towerSprite.frame = 2
		elif angle > 45 and angle < 135:
			towerSprite.frame = 0
		elif angle >= 135 or angle <= -135:
			towerSprite.frame = 1
		else:
			towerSprite.frame = 3

		var direction := global_position.direction_to(curr.global_position)

		aimMark.global_position = global_position + direction

		if canShoot:
			print("shoot")
			Shoot()
			canShoot = false

	updateStats()


func find_target() -> void:
	var targets := rangeArea.get_overlapping_bodies()
	var bestTarget: Node2D = null
	var bestProgress := 0.0

	for body in targets:
		if not body.is_in_group("enemy"):
			continue

		if not is_instance_valid(body):
			continue

		if body.is_queued_for_deletion():
			continue

		var pathFollow = body.get_parent()

		if not pathFollow is PathFollow2D:
			continue

		var progress = pathFollow.progress

		if bestTarget == null:
			bestTarget = body
			bestProgress = progress
			continue

		if priorityTarget == targetTypes.FIRST:
			# FIRST = farthest along the path
			if progress > bestProgress:
				bestTarget = body
				bestProgress = progress

		else:
			# LAST = furthest back on the path
			if progress < bestProgress:
				bestTarget = body
				bestProgress = progress

	curr = bestTarget


func Shoot() -> void:

	if not is_instance_valid(curr):
		return

	if curr.is_queued_for_deletion():
		return

	var tempShot = bulletType.instantiate()
	tempShot.target = curr

	tempShot.bulletDamage = damage

	get_tree().current_scene.add_child(tempShot)
	tempShot.global_position = aimMark.global_position


func updateStats() -> void:
	nameplate.text = towerType
	damageNum.text = str(damage)
	speedNum.text = str(shotSpeed)
	rangeNum.text = str(targetRange)
	costLabel.text = str(upgradeCost)


func _on_range_area_body_entered(body: Node2D) -> void:

	if body.is_in_group("enemy"):
		find_target()


func _on_range_area_body_exited(body: Node2D) -> void:

	if body == curr:
		curr = null
		find_target()


func upgradeStats() -> void:

	level += 1
	targetRange += 20
	damage *= 2
	shotSpeed += 1
	upgradeCost *= 2
	rangeCollider.shape.set_deferred("radius", targetRange)
	shotTimer.wait_time = 1.0 / shotSpeed


func _on_tower_area_input_event(viewport: Node,event: InputEvent,shape_idx: int) -> void:

	if event is InputEventMouseButton and event.button_mask == 1:
		
		upgradeMenu.show()
		updateStats()

func _on_upgrade_button_pressed() -> void:
	rangeDisplay.show()
	if GlobalScript.playerCash >= currUpgradeCost:

		GlobalScript.playerCash -= currUpgradeCost
		currUpgradeCost *= 2

		upgradeStats()


func _on_shot_timer_timeout() -> void:

	canShoot = true
