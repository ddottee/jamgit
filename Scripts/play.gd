extends TextureButton

@onready var level = preload("res://Scenes/levels.tscn")
func _on_pressed() -> void:
	GlobalScript.gameState = GlobalScript.gameStates.PAUSE
	get_tree().change_scene_to_file("res://Scenes/levels.tscn")
