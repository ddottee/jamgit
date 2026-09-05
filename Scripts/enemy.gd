extends PathFollow2D
class_name Enemy


@export_group("Stats")

@export var health:= 10
@export var speed := 5
@export var damage := 1


@export_group("Behavior")


@export var inAir := false
@export var FinishRatio := 99.0

func _ready() -> void:
	self.progress = 0


func _process(delta: float) -> void:
	self.progress += speed * delta * GlobalScript.speedMult
	if progress_ratio >= FinishRatio:
		damagePlayer()
		
		
func damagePlayer():
	pass
