class_name EnemySpawn
extends Node3D

var enemy_scene := preload("res://enemy.tscn")
var spawn_timer : float = 1

@onready var possible_spawns = $PossibleSpawns

func _process(delta: float) -> void:
	delta = delta * EventBus.delta_modifier_non_player
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		spawn_timer = 1
	

func spawn_enemy() -> void:
	var offset: int = randi_range(15,25)
	for child in possible_spawns.get_children():
		if child.entity_counter == 0 and EventBus.enemy_count < 10:
			var enemy : Enemy = enemy_scene.instantiate()
			enemy.update_frame_offset = offset
			get_parent().add_child(enemy)
			enemy.global_position = child.global_position
			EventBus.enemy_spawned.emit()
			return
			
func _on_timer_timeout() -> void:
	spawn_enemy()
