class_name UpgradePoint
extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	(body as Player).on_upgrade_point_entered()
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	(body as Player).on_upgrade_point_exited()
