class_name PossibleSpawnPosition
extends Node3D

var is_free : bool = true
var entity_counter : int = 0

func _on_spawn_body_entered(_body: Node3D) -> void:
	entity_counter += 1

func _on_spawn_body_exited(_body: Node3D) -> void:
		entity_counter -= 1
