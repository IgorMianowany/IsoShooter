class_name Gun
extends Node3D

var bullet := load("res://bullet.tscn")
var current_magazine : int
var magazine_size : int
var magazines : int
var instance : Bullet
var reload_time : float = 1
var bullet_pierce
@export var player : Player

@warning_ignore("unused_signal") signal reload_finished

func _ready() -> void:
	current_magazine = magazine_size

func _shoot():
	pass
	
func _reload():
	await(get_tree().create_timer(reload_time).timeout)
	current_magazine = magazine_size
