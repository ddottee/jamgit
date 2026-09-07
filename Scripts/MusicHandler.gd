extends AudioStreamPlayer

@export var menuMusic : AudioStream
@export var gameMusic : AudioStream

@export var musicVolume = 1
@export var sfxVolume = 1
func _ready() -> void:
	self.stream = menuMusic
	self.autoplay = true
	self.seek(0)
	self.playing = true
	self.play()

	
	
func _process(_delta: float) -> void:
	if not self.playing:
		self.play()
	if get_tree().current_scene:
		if get_tree().current_scene.is_in_group("GameplayMusic") and self.stream != gameMusic:
			self.stream = gameMusic
	elif self.stream != menuMusic:
		self.stream = menuMusic
