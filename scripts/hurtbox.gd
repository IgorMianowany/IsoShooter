class_name Hurtbox
extends Area3D


func _on_area_entered(area: Area3D) -> void:
	owner.take_damage(area.damage, area.owner.global_position)
