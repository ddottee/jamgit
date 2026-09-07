extends Control

@onready var settingsPath = preload("res://Scenes/settings.tscn")
@onready var settings: TextureButton = $HBoxContainer/buttons/Settings

func _ready() -> void:
	var temp = settingsPath.instantiate()
	settings.add_child(temp)
