class_name EnemySpawn
extends Node3D

var enemy_scene := preload("res://enemy.tscn")

@onready var possible_spawns = $PossibleSpawns

func spawn_enemy() -> void:
	var offset: int = randi_range(15,25)
	for child in possible_spawns.get_children():
		if child.entity_counter == 0 and EventBus.enemy_count < 13:
			var enemy : Enemy = enemy_scene.instantiate()
			enemy.update_frame_offset = offset
			get_parent().add_child(enemy)
			enemy.global_position = child.global_position
			EventBus.enemy_spawned.emit()
			return
			
func _on_timer_timeout() -> void:
	spawn_enemy()
