class_name PlayerUI
extends Control

var shop_scene := preload("res://shop.tscn")
var is_shop_open : bool = false

@export var player : Player

@onready var interact_label = $CanvasLayer/MarginContainer/InteractLabel
@onready var shop_holder = $ShopHolder
@onready var health = $CanvasLayer/MarginContainer2/Health
@onready var points = $CanvasLayer/MarginContainer3/Points
@onready var ammo = $CanvasLayer/VBoxContainer/MarginContainer4/Ammo
@onready var magazines = $CanvasLayer/VBoxContainer/MarginContainer4/Magazines
@onready var weapon1 : Label = $CanvasLayer/VBoxContainer/MarginContainer/Weapon1
@onready var weapon2 : Label = $CanvasLayer/VBoxContainer/MarginContainer2/Weapon2

func _ready() -> void:
	interact_label.text = "Press 'e' to open shop"
	EventBus.enemy_spawned.connect(update_enemy_count)
	EventBus.enemy_died.connect(update_enemy_count)
	EventBus.upgrade_selected.connect(update_weapons)
	$CanvasLayer/MarginContainer4/TimeSlowToggleResource.max_value = player.time_slow_resource
	
func _process(_delta: float) -> void:
	health.text = str(int(player.health)) + "/" + str(int(player.max_health))
	points.text = "points: " + str(int(EventBus.points))
	ammo.text = str(player.get_current_magazine()) + "/" + str(player.get_magazine_size())
	if player.is_reloading:
		ammo.text = "reloading"
	$CanvasLayer/MarginContainer4/TimeSlowToggleResource.value = player.time_slow_resource
func show_interact_label():
	interact_label.visible = true
	
func hide_interact_label():
	interact_label.visible = false

func show_shop():
	if is_shop_open:
		return
	is_shop_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	shop_holder.add_child(shop_scene.instantiate())
	hide_interact_label()
	
func hide_shop():
	var shops = shop_holder.get_children()
	for shop in shops:
		shop.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	is_shop_open = false
	
func update_enemy_count():
	$CanvasLayer/EnemyCount.text = "Enemy count: " + str(EventBus.enemy_count)
	
func update_weapons(upgrade_type : Guns.weapons):
	match upgrade_type:
		0:
			weapon2.text = "Pistol"
		1:
			weapon2.text = "Pistols"
		4:
			weapon1.text = "Shotgun"
	
	
		
		

	
