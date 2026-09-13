extends CharacterBody2D
class_name Enemy


@export_group("Stats")

@export var health:= 5
@export var speed := 50
@export var damage := 1
@export var cashVal := 2

@export_group("Behavior")


@export var inAir := false
@export var FinishRatio := .990
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var path = get_parent()
func _ready() -> void:
	path.progress = 0
	

func _process(delta: float) -> void:
	path.progress += speed * delta * GlobalScript.speedMult
	if path.progress_ratio >= FinishRatio:
		damagePlayer()
	if health <= 0:
		die()
		
func damagePlayer():
	GlobalScript.takeDamage(damage)
	queue_free()

func die():
	print(GlobalScript.enemies)
	GlobalScript.playerCash += cashVal
	if GlobalScript.enemies > 0:
		GlobalScript.enemies -= 1
	
	SignalBus.emit_signal("updateCash")
	queue_free()
