extends TextureButton

@onready var settingsScene = preload("res://Scenes/settings.tscn")
func _on_pressed() -> void:
	
	if self.get_child_count() > 0:
		for i in self.get_child_count():
			self.get_child(i).size = Vector2(538, 810)
			self.get_child(i).global_position = Vector2(451, 0.0)
			self.get_child(i).show()
	
