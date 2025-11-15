class_name Guns
extends Node3D

enum weapons {PISTOL, PISTOL_AKIMBO, RIFLE, RIFLE_AKIMBO, SHOTGUN, SNIPER}

var available_weapons = [weapons.PISTOL, weapons.PISTOL_AKIMBO,weapons.RIFLE]
var is_akimbo : bool = false

@onready var akimbo_weapon : Gun = $Pistol2
@onready var current_weapon : Gun = $Pistol

func shoot():
	current_weapon._shoot()
	if is_akimbo:
		akimbo_weapon._shoot()
	
func switch_weapon(to : weapons):
	#var child : Node3D
	#child = find_child("Pistol")
	if (available_weapons.has(to)):
		current_weapon.visible = false
		akimbo_weapon.visible = false
		is_akimbo = false
		match to:
			weapons.PISTOL:
				current_weapon = find_child("Pistol")
			weapons.PISTOL_AKIMBO:
				is_akimbo = true
				akimbo_weapon = find_child("Pistol2")
				akimbo_weapon.visible = true
			weapons.RIFLE:
				current_weapon = find_child("Rifle2")
		current_weapon.visible = true
