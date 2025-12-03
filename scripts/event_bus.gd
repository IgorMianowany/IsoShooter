extends Node

var enemy_count : int = 0

@warning_ignore_start("unused_signal")
signal upgrade_selected(upgrade_type)
signal enemy_spawned

func _ready():
	enemy_spawned.connect(add_enemy)

func add_enemy():
	enemy_count += 1
