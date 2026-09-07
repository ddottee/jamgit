extends Panel


@onready var upgradeBar = $upgradeBar
@onready var upgradeCont = $upgradeBar/upgradeCont

@onready var damageNum = $upgradeBar/upgradeCont/damageNum
@onready var rangeNum = $upgradeBar/upgradeCont/rangeNum
@onready var speedNum = $upgradeBar/upgradeCont/speedNum

@onready var closeButton = $closeButton
@onready var upgradeButton = $upgradeButton
@onready var targetTypeButton = $targetTypeButton

@onready var towerIcon = $towerIcon

func _ready() -> void:
	closeButton.connect("button_down", close)
	#self.scale = Vector2(2.5,2.5)
func close():
	hide()
	
