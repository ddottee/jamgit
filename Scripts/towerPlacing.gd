extends Node2D

@export var towerScene : PackedScene

@export var cost := 5

var preview : Node2D
var canPlace := false

func _ready() -> void:
	preview = towerScene.instantiate()
