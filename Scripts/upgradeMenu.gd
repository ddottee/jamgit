extends Panel


@onready var upgradeBar = $upgradeBar


@onready var upgradeButton: TextureButton = $upgradeBar/upgradeButton

@onready var closeButton = $closeButton
@onready var targetTypeButton = $targetTypeButton
@onready var nameplate: Label = %nameplate

@onready var towerIcon: Sprite2D = %towerIcon


var dragging := false
var dragOffset := Vector2.ZERO

func _ready() -> void:
	
	closeButton.connect("button_down", close)
	#self.scale = Vector2(2.5,2.5)

func _process(delta: float) -> void:
	if self.visible:
		if Input.is_key_pressed(KEY_ESCAPE):
			close()

func close():
	hide()
	self.position = Vector2.ZERO
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				dragging = true
				dragOffset = global_position - get_global_mouse_position()
func _input(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.is_pressed():
			dragging = false
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + dragOffset
