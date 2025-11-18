class_name PlayerUI
extends Control

var shop := preload("res://shop.tscn")

@onready var interact_label = $CanvasLayer/MarginContainer/Label
@onready var shop_holder = $ShopHolder

func _ready() -> void:
	interact_label.text = "Press 'e' to open shop"

func show_interact_label():
	interact_label.visible = true
	
func hide_interact_label():
	interact_label.visible = false

func show_shop():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	shop_holder.add_child(shop.instantiate())
	
func hide_shop():
	var shops = shop_holder.get_children()
	for shop in shops:
		shop.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		
		
	
