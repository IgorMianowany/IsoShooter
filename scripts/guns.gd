class_name Guns
extends Node3D

enum weapons {PISTOL, PISTOL_AKIMBO, RIFLE, RIFLE_AKIMBO, SHOTGUN, SNIPER}

var available_weapons = [weapons.PISTOL]
var is_akimbo : bool = false

@onready var player : Player = get_parent()
@onready var akimbo_weapon : Gun = $Pistol2
@onready var current_weapon : Gun = $Pistol

func _ready():
	EventBus.upgrade_selected.connect(handle_upgrade_selected)

func shoot():
	current_weapon._shoot()
	if is_akimbo:
		akimbo_weapon._shoot()
	
func switch_weapon(to : weapons):
	if (available_weapons.has(to)):
		current_weapon.visible = false
		akimbo_weapon.visible = false
		is_akimbo = false
		match to:
			weapons.PISTOL:
				current_weapon = find_child("Pistol")
			weapons.PISTOL_AKIMBO:
				current_weapon = find_child("Pistol")
				is_akimbo = true
				akimbo_weapon = find_child("Pistol2")
				akimbo_weapon.visible = true
			weapons.RIFLE:
				current_weapon = find_child("Rifle2")
			weapons.SHOTGUN:
				current_weapon = find_child("Shotgun")
		current_weapon.visible = true
		
func handle_upgrade_selected(upgrade_type : Guns.weapons):
	available_weapons.append(upgrade_type)
	if upgrade_type == 1:
		player.second_weapon = upgrade_type
	else:	
		player.first_weapon = upgrade_type
	switch_weapon(upgrade_type)
	
func get_current_magazine() -> int:
	return current_weapon.current_magazine

func get_magazine_size() -> int:
	return current_weapon.magazine_size
	
func get_magazines() -> int:
	return current_weapon.magazines
