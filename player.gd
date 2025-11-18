class_name Player
extends CharacterBody3D

var camera_rotation_speed : float = 200
var jump_velocity = 50
var speed : float = 100
var friction : float = 0.9
var fall_speed : float = 10
var move_direction = Vector3()
var first_weapon : Guns.weapons
var second_weapon : Guns.weapons
var can_open_shop : bool = false

@onready var pointer_raycast : RayCast3D = $PointerRayCast

@onready var camera = $CameraRig/Camera
@onready var camera_rig = $CameraRig
@onready var cursor = $Cursor
@onready var current_emitter = $MachineGunEmitter
@onready var guns = $Guns
@onready var ui = $PlayerUI
@onready var laser_pointer = $LaserPointer

## second gun
@onready var gun_anim2 : AnimationPlayer = $Guns/Rifle2/SteampunkRifle/AnimationPlayer
@onready var gun_barrel2 = $Guns/Rifle2/RayCast3D

func _ready():
	camera_rig.set_as_top_level(true)
	cursor.set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	guns.switch_weapon(guns.weapons.PISTOL)
	first_weapon = Guns.weapons.SHOTGUN
	second_weapon = Guns.weapons.PISTOL

func _physics_process(delta):
	$CanvasLayer/FPS.text = str(Engine.get_frames_per_second())
	
	camera_follows_player()
	rotate_camera(delta)
	
	look_at_cursor()
	move_player(delta)
	
	velocity *= friction
	if not is_on_floor():
		velocity += get_gravity() * delta * fall_speed
	move_and_slide()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		#$Guns/Rifle._shoot()
		#$Guns/Rifle2._shoot()
		guns.shoot()
	var laser_collision_point
	if pointer_raycast.is_colliding():
		laser_collision_point = pointer_raycast.get_collision_point()
		var current_length: float = laser_pointer.get_aabb().size.y
		var factor = global_position.distance_to(laser_collision_point) / current_length
		laser_pointer.scale *= factor  # uniform scaling
	#else:
		## scale laser to max distance


func _input(event):
	if event.is_action("exit"):
		get_tree().quit()
	if event.is_action_pressed("shoot"):
		current_emitter.restart()
		current_emitter.emitting = false
	if event.is_action_released("shoot"):
		current_emitter.emitting = false
	if event.is_action("weapon_1"):
		guns.switch_weapon(first_weapon)
	if event.is_action("weapon_2"):
		guns.switch_weapon(second_weapon)
	if can_open_shop and event.is_action_pressed("interact"):
		ui.show_shop()


func camera_follows_player():
	var player_pos = global_transform.origin
	camera_rig.global_transform.origin = player_pos

func rotate_camera(delta):
	if Input.is_action_pressed("rotate_camera_clockwise"):
		camera_rig.rotate_y(deg_to_rad(-camera_rotation_speed * delta)) 
	if Input.is_action_pressed("rotate_camera_counterclockwise"):
		camera_rig.rotate_y(deg_to_rad(camera_rotation_speed * delta)) 


func look_at_cursor():
	# Create a horizontal plane, and find a point where the ray intersects with it
	var player_pos = global_transform.origin
	var dropPlane  = Plane(Vector3(0, 1, 0), player_pos.y)
	# Project a ray from camera, from where the mouse cursor is in 2D viewport
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from,to)
	
	if cursor_pos != null:
		cursor.global_transform.origin = cursor_pos + Vector3(0,0,0)
		# Make player look at the cursor
		look_at(cursor_pos, Vector3.UP)
#
#
func move_player(delta):
	move_direction = Vector3()
	var camera_basis = camera.get_global_transform().basis
	# for some reason camera basis on Y axis is not 0, not sure why but it makes you fly when moving backwards
	camera_basis.z.y = 0
	if Input.is_action_pressed("move_forward"):
		move_direction -= camera_basis.z
	elif Input.is_action_pressed("move_back"):
		move_direction += camera_basis.z
	if Input.is_action_pressed("move_left"):
		move_direction -= camera_basis.x
	elif Input.is_action_pressed("move_right"):
		move_direction += camera_basis.x
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_velocity

	move_direction = move_direction.normalized()
	
	velocity += move_direction * speed * delta

func on_upgrade_point_entered():
	ui.show_interact_label()
	can_open_shop = true

func on_upgrade_point_exited():
	ui.hide_interact_label()
	can_open_shop = false
	ui.hide_shop()
