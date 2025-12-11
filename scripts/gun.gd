class_name Gun
extends Node3D

var bullet := load("res://bullet.tscn")
var current_magazine : int
var magazine_size : int
var magazines : int
var instance
@export var player : Player

func _ready() -> void:
	current_magazine = magazine_size

func _shoot():
	pass
