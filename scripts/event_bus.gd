extends Node

var enemy_count : int = 0

@warning_ignore_start("unused_signal")
signal upgrade_selected(upgrade_type)
signal enemy_spawned
signal enemy_died

func _ready():
	enemy_spawned.connect(add_enemy)
	enemy_died.connect(remove_enemy)

func add_enemy():
	enemy_count += 1
func remove_enemy():
	enemy_count -= 1
