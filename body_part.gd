class_name BodyPart
extends Area3D

#@export var damage := 1

signal body_part_hit(damage)
	
func hit(damage):
	emit_signal("body_part_hit", damage * 10)
