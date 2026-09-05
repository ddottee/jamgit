extends CharacterBody2D
class_name Enemy


@export_group("Stats")

@export var health:= 10
@export var speed := 50
@export var damage := 1


@export_group("Behavior")


@export var inAir := false
@export var FinishRatio := 99.0


@onready var path = get_parent()
func _ready() -> void:
	path.progress = 0


func _process(delta: float) -> void:
	path.progress += speed * delta * GlobalScript.speedMult
	if path.progress_ratio >= FinishRatio:
		damagePlayer()
		
		
func damagePlayer():
	pass
