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
@onready var time_slow_icon : SkillIcon = $CanvasLayer/MarginContainer4/HBoxContainer/TimeSlow
@onready var rewind_icon : SkillIcon = $CanvasLayer/MarginContainer4/HBoxContainer/Rewind
@onready var time_slow_resource : ProgressBar = $CanvasLayer/MarginContainer4/HBoxContainer/TimeSlowToggleResource

func _ready() -> void:
	interact_label.text = "Press 'e' to open shop"
	EventBus.enemy_spawned.connect(update_enemy_count)
	EventBus.enemy_died.connect(update_enemy_count)
	EventBus.upgrade_selected.connect(update_weapons)
	time_slow_resource.max_value = player.time_slow_resource
	time_slow_icon.max_progress = player.time_stop_cooldown
	
func _process(_delta: float) -> void:
	health.text = str(int(player.health)) + "/" + str(int(player.max_health))
	points.text = "points: " + str(int(EventBus.points))
	ammo.text = str(player.get_current_magazine()) + "/" + str(player.get_magazine_size())
	if player.is_reloading:
		ammo.text = "reloading"
		
	if player.is_time_stop:
		time_slow_icon.toggle_fill_type(TextureProgressBar.FILL_COUNTER_CLOCKWISE)
	else:
		time_slow_icon.toggle_fill_type(TextureProgressBar.FILL_CLOCKWISE)

	time_slow_resource.value = player.time_slow_resource
	time_slow_icon.max_progress = player.time_stop_cooldown
	time_slow_icon.progress = player.time_stop_cooldown - player.time_stop_cooldown_timer
	
	
	
	$Debug/VBoxContainer/TimeStopCooldown.text = str(player.time_stop_cooldown)
	$Debug/VBoxContainer/timeStopCurrentColdwon.text = str(player.time_stop_cooldown_timer)
	
	
	
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
	
	
		
		

	
