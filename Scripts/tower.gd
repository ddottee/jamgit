extends StaticBody2D
class_name Tower

@onready var rangeCollider: CollisionShape2D = $rangeArea/rangeCollider
@onready var rangeArea: Area2D = $rangeArea
@onready var shotTimer: Timer = $shotTimer
@onready var bulletContainer: Node = $bulletContainer
@onready var aimMark: Marker2D = $aimMark
@onready var upgradeMenu : Panel = $upgradeMenu
enum targetTypes {FIRST, LAST}

@export_group("Stats")

@export var level := 1
@export var damage := 1
@export var bulletType : PackedScene
@export var targetRange := 100
@export var shotSpeed := 1


@export_group("Behavior")

@export var priorityTarget = targetTypes.FIRST
@export var canTargetAir := false


@export_group("Costs")
@export var cost := 1
@export var upgradeCost := 2
@onready var currUpgradeCost = upgradeCost


var currTargets = []
var curr
var pathName
var startShoot := false

func _ready() -> void:
	rangeArea.body_entered.connect(_on_range_area_body_entered)
	rangeArea.body_exited.connect(_on_range_area_body_exited)
	rangeCollider.shape.set_deferred("radius", targetRange)
	upgradeMenu.hide()
	
func _process(delta: float) -> void:
	if is_instance_valid(curr):
		self.look_at(curr.global_position)
		if shotTimer.is_stopped():
			Shoot()
			shotTimer.start()
	else:
		for i in get_node("bulletContainer").get_child_count():
			get_node("bulletContainer").get_child(i).queue_free()
	updateStats()


func Shoot():
	var tempShot = bulletType.instantiate()
	tempShot.pathName = pathName
	tempShot.bulletDamage = damage
	get_node("bulletContainer").add_child(tempShot)
	tempShot.global_position = aimMark.global_position

func updateStats():
	pass



func _on_range_area_body_entered(body: Node2D) -> void:
	if body.is_class("Enemy"):
		var tempArr = []
		currTargets = get_node("rangeArea").get_overlapping_bodies()
		for i in currTargets:
			if i.is_class("Enemy"):
				tempArr.append(i)
		
		var currTarget = null
		
		for i in tempArr:
			if currTarget == null:
				currTarget = i.get_node("../")
			else:
				if priorityTarget == targetTypes.FIRST:
					if i.get_parent().get_progress() > currTarget.get_progress():
						currTarget = i.get_node("../")
				else:
					if i.get_parent().get_progress() < currTarget.get_progress():
						currTarget = i.get_node("../")
				curr = currTarget
				pathName = currTarget.get_parent().name

func upgradeStats():
	level += 1
	targetRange *= 1.5
	damage *= 2
	shotSpeed *= 2

func _on_range_area_body_exited(body: Node2D) -> void:
	currTargets = get_node("rangeArea").get_overlapping_bodies()
	


func _on_tower_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:
		upgradeMenu.show()


func _on_upgrade_button_pressed() -> void:
	if GlobalScript.playerCash >= currUpgradeCost:
		GlobalScript.playerCash -= currUpgradeCost
		currUpgradeCost *= 2
		upgradeStats()
		
