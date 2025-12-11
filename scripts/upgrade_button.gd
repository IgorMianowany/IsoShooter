class_name UpgradeButton
extends Control

@onready var texture_rect : TextureRect = $Panel/MarginContainer3/TextureRect
@onready var label = $Panel/MarginContainer2/Label
@onready var button : Button = $Panel/MarginContainer/Button

@export var upgrade_type : Guns.weapons

func _ready() -> void:
	#button.disabled = false
	match upgrade_type:
		Guns.weapons.PISTOL_AKIMBO:
			label.text = "Unlock Dual Pistols"
			
		Guns.weapons.SHOTGUN:
			texture_rect.texture = load("res://icons/Shotgun.png")
			label.text = "Unlock Shotgun"

		Guns.weapons.RIFLE:
			pass
		Guns.weapons.RIFLE_AKIMBO:
			pass
		Guns.weapons.SNIPER:
			pass

func _on_button_pressed() -> void:
	EventBus.upgrade_selected.emit(upgrade_type)
	button.disabled = true
