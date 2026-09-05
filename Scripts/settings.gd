extends TextureButton

@onready var settingsScene = preload("res://Scenes/settings.tscn")
func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
