class_name Guns
extends Node3D

enum weapons {PISTOL, PISTOL_AKIMBO, RIFLE, RIFLE_AKIMBO, SHOTGUN, SNIPER}

var available_weapons = [weapons.PISTOL, weapons.RIFLE]

var akimbo_weapon : Gun = null
@onready var current_weapon : Gun = $Pistol

func shoot():
	current_weapon._shoot()
	
func switch_weapon(to : weapons):
	#var child : Node3D
	#child = find_child("Pistol")
	if (available_weapons.has(to)):
		current_weapon.visible = false
		match to:
			weapons.PISTOL:
				current_weapon = find_child("Pistol")
			weapons.RIFLE:
				current_weapon = find_child("Rifle2")
		current_weapon.visible = true
