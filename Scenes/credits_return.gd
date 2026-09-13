extends TextureButton

@onready var credits: TextureRect = %credits

@onready var menuButtons: HBoxContainer = %mainMenuButtons

func _on_pressed() -> void:
	credits.hide()
	menuButtons.show()
