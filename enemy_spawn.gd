class_name EnemySpawn
extends Node3D

var enemy_scene := preload("res://enemy.tscn")

func spawn_enemy():
	var enemy : Enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = global_position


func _on_timer_timeout() -> void:
	spawn_enemy()
