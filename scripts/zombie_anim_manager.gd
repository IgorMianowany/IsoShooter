class_name ZombieAnimManager
extends Node3D

signal attack_start
signal attack_end

func attack_started():
	attack_start.emit()

func attack_ended():
	attack_end.emit()
