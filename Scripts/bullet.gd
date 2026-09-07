extends CharacterBody2D
@onready var bulletSprite: Sprite2D = $bulletSprite

@onready var collision: Area2D = $Collision
@onready var centerCollider: Area2D = $centerCollider

var target : Node2D = null
var pathName = ""
@export_group("Stats")
@export var speed := 1000
@export var bulletDamage := 1


	
func _physics_process(delta: float) -> void:
	if not is_instance_valid(target) or target.is_queued_for_deletion():
		queue_free()
		return

	var target_position = target.global_position

	velocity = global_position.direction_to(target_position) * speed
	look_at(target_position)
	move_and_slide()



func _on_center_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		queue_free()

func _on_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.health -= bulletDamage
