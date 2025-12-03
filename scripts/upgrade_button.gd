class_name UpgradeButton
extends Control

@export var upgrade_type : Guns.weapons

func _on_button_pressed() -> void:
	print(upgrade_type)
	EventBus.upgrade_selected.emit(upgrade_type)
