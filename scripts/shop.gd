class_name Shop
extends Control

@onready var budget := $CanvasLayer/MarginContainer/Budget

func _process(_delta: float) -> void:
	budget.text = str(EventBus.points) + "$"
	
