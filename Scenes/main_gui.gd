extends Control

@onready var credits: TextureRect = %credits
@onready var menuButton: HBoxContainer = %mainMenuButtons

func _ready() -> void:
	menuButton.show()
	credits.hide()
