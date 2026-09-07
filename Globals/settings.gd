extends Control


@onready var music: TextureProgressBar = $background/HBoxContainer/bars/music
@onready var sfx: TextureProgressBar = $background/HBoxContainer/bars/sfx
@onready var close: Button = $close
@onready var sfx_slider: HSlider = $background/HBoxContainer/bars/sfx/sfxSlider
@onready var music_slider: HSlider = $background/HBoxContainer/bars/music/musicSlider

func _ready() -> void:
	self.hide()

func _process(delta: float) -> void:
	music.value = music_slider.value
	sfx.value = sfx_slider.value
	music_slider.value_changed
	GlobalScript.musicVol = music.get_value()
	GlobalScript.sfxVol = sfx.get_value()

	

func _on_close_pressed() -> void:
	self.hide()
