class_name Tower

enum targetTypes {FIRST, LAST, NEAREST}

@export_group("Stats")

@export var damage := 1
@export var targetRange := 1
@export var projectileSpeed := 1


@export_group("Behavior")

@export var priorityTarget = targetTypes.FIRST
@export var canTargetAir := false



@export_group("Costs")
@export var cost := 1
@export var upgradeCost := 1
