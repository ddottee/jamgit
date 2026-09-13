extends TextureButton

@onready var credits: TextureRect = %credits
@onready var menuButtons: HBoxContainer = %mainMenuButtons

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



func _on_pressed() -> void:
	credits.show()
	menuButtons.hide()
