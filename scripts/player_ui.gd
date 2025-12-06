class_name PlayerUI
extends Control

var shop_scene := preload("res://shop.tscn")

@export var player : Player

@onready var interact_label = $CanvasLayer/MarginContainer/Label
@onready var shop_holder = $ShopHolder

func _ready() -> void:
	interact_label.text = "Press 'e' to open shop"
	EventBus.enemy_spawned.connect(update_enemy_count)
	
func _process(_delta: float) -> void:
	$CanvasLayer/Health.text = str(player.health)

func show_interact_label():
	interact_label.visible = true
	
func hide_interact_label():
	interact_label.visible = false

func show_shop():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	shop_holder.add_child(shop_scene.instantiate())
	
func hide_shop():
	var shops = shop_holder.get_children()
	for shop in shops:
		shop.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func update_enemy_count():
	$CanvasLayer/EnemyCount.text = str(EventBus.enemy_count)
		
		

	
