extends Node

var enemy_count : int = 0
var points : int = 0
var delta_modifier_non_player : float = 1

@warning_ignore_start("unused_signal")
signal upgrade_selected(upgrade_type)
signal enemy_spawned
signal enemy_died
signal time_stop_start(time)
signal time_stop_stop

func _ready():
	enemy_spawned.connect(add_enemy)
	enemy_died.connect(remove_enemy)
	time_stop_start.connect(stop_time)

func add_enemy():
	enemy_count += 1
func remove_enemy():
	enemy_count -= 1
	points += 1
	
func stop_time(time : float):
	delta_modifier_non_player = 0
	await(get_tree().create_timer(time).timeout)
	delta_modifier_non_player = 1
	time_stop_stop.emit()
	
