class_name Player
extends CharacterBody3D

var camera_rotation_speed : float = 200
var jump_velocity = 30
var speed : float = 100
var friction : float = 0.9
var gravity : float = 19
var move_direction = Vector3()

var bullet := load("res://bullet.tscn")
var instance

@onready var camera = $CameraRig/Camera
@onready var camera_rig = $CameraRig
@onready var cursor = $Cursor
@onready var current_emitter = $MachineGunEmitter
@onready var gun_anim : AnimationPlayer = $Rifle/SteampunkRifle/AnimationPlayer
@onready var gun_barrel = $Rifle/RayCast3D
## second gun
@onready var gun_anim2 : AnimationPlayer = $Rifle2/SteampunkRifle/AnimationPlayer
@onready var gun_barrel2 = $Rifle2/RayCast3D

func _ready():
	camera_rig.set_as_top_level(true)
	cursor.set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event):
	if event.is_action("exit"):
		get_tree().quit()
	if event.is_action_pressed("shoot"):
		current_emitter.restart()
		current_emitter.emitting = false
	if event.is_action_released("shoot"):
		current_emitter.emitting = false
	if event.is_action("weapon_1"):
		current_emitter = $MachineGunEmitter
	if event.is_action("weapon_2"):
		current_emitter = $ShotgunEmitter


func _physics_process(delta):
	if Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			
			gun_anim2.play("shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel2.global_position
			instance.transform.basis = gun_barrel2.global_transform.basis
			get_parent().add_child(instance)
			
	
	camera_follows_player()
	rotate_camera(delta)
	
	look_at_cursor()
	run(delta)
	
	velocity *= friction
	velocity.y -= gravity * delta
	move_and_slide()


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
func run(delta):
	move_direction = Vector3()
	var camera_basis = camera.get_global_transform().basis
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
	#move_direction.y = 0
	move_direction = move_direction.normalized()
	
	velocity += move_direction * speed * delta

	
