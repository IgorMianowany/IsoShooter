class_name Hitbox
extends Area3D

signal hit

var damage : float = 10

func _ready() -> void:
	hit.connect(handle_hit)

func handle_hit():
	set_deferred("monitorable", false)
	