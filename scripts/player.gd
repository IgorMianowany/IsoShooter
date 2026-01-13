class_name Player
extends CharacterBody3D

var camera_rotation_speed : float = 200
var jump_velocity: int = 50
var speed : float = 100
var friction : float = 0.9
var fall_speed : float = 10
var move_direction: Vector3 = Vector3()
var first_weapon : Guns.weapons
var second_weapon : Guns.weapons
var can_open_shop : bool = false
var health : float = 100
var max_health : float = 100
var is_reloading : bool = false
var skill_timer : int = 2
var skill_time : int = 2
var time_warp_positions : Array[Transform3D] #= [Vector3.ZERO,Vector3.ZERO,Vector3.ZERO,Vector3.ZERO]
var time_warp_hps : Array[float]
var time_warp_cooldown : float = 1
var time_warp_counter : int = 1
var is_time_warping : bool = false
var delta_modifier : float = 1
var time_slow_resource : float = 2
var is_time_slow_toggled : bool = false
var time_stop_cooldown : float =  3
var time_stop_cooldown_timer : float = 0
var is_time_stop : bool = false

@onready var camera = $CameraRig/Camera
@onready var camera_rig = $CameraRig
@onready var cursor = $Cursor
@onready var current_emitter = $MachineGunEmitter
@onready var guns = $Guns
@onready var ui: PlayerUI = $PlayerUI
@onready var take_damage_emitter : GPUParticles3D = $TakeDamageEmitter
@onready var time_warp_timer : Timer = $TimeWarpTimer
@onready var shockwave_anim : AnimationPlayer = $Shockwave/ShockwaveAnim
@onready var player_anim : AnimationPlayer = $Player/AnimationPlayer

## second gun
@onready var gun_anim2 : AnimationPlayer = $Guns/Rifle2/SteampunkRifle/AnimationPlayer
@onready var gun_barrel2 = $Guns/Rifle2/RayCast3D

func _ready():
	camera_rig.set_as_top_level(true)
	cursor.set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	guns.switch_weapon(guns.weapons.PISTOL)
	#first_weapon = Guns.weapons.SHOTGUN
	second_weapon = Guns.weapons.PISTOL
	guns.reload_finished.connect(reload_finished)
	time_warp_timer.timeout.connect(add_time_warp_position)
	for child in $GhostMarkers.get_children():
		child.set_as_top_level(true)

func _physics_process(delta):
	delta *= delta_modifier
	$CanvasLayer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())

	move_player(delta)
	
	velocity *= friction
	if not is_on_floor():
		velocity += get_gravity() * delta * fall_speed
	move_and_slide()
	if ui.is_shop_open:
		return
	camera_follows_player()
	rotate_camera(delta)
	
	look_at_cursor()
	
func _process(delta: float) -> void:
	time_warp_cooldown -= delta
	if ui.is_shop_open:
		return
	if not is_reloading and Input.is_action_pressed("shoot"):
		#$Guns/Rifle._shoot()
		#$Guns/Rifle2._shoot()
		guns.shoot()
		
	if is_time_slow_toggled:
		time_slow_resource -= delta
		if time_slow_resource < 0:
			toggle_time_slow()
	elif time_slow_resource < 2:
		time_slow_resource += delta/2
		
	if time_stop_cooldown_timer > 0:
		time_stop_cooldown_timer -= delta


func _input(event):
	if event.is_action("exit"):
		get_tree().quit()
	if event.is_action_pressed("shoot"):
		current_emitter.restart()
		current_emitter.emitting = false
	if not is_reloading and event.is_action_released("shoot"):
		current_emitter.emitting = false
	if event.is_action("weapon_1"):
		guns.switch_weapon(first_weapon)
	if event.is_action("weapon_2"):
		guns.switch_weapon(second_weapon)
	#$Laser2.visible = guns.is_akimbo
	if can_open_shop and event.is_action_pressed("interact"):
		ui.show_shop()
	if event.is_action_pressed("reload"):
		reload()
	if event.is_action("use_skill_1") and Engine.time_scale == 1:
		$Shockwave/ShockwaveAnim.speed_scale *= 4
		time_skill_effect()
		time_slow()
		await($Shockwave/ShockwaveAnim.animation_finished)
		$Shockwave/ShockwaveAnim.speed_scale *= .25
	if event.is_action("use_skill_2") and time_warp_cooldown < 0:
		time_warp_cooldown = 1
		time_warp()
	if event.is_action_pressed("use_skill_3"):
		toggle_time_slow()
	if event.is_action_pressed("use_skill_4") and time_stop_cooldown_timer <= 0:
		is_time_stop = true
		time_stop_cooldown_timer = time_stop_cooldown
		shockwave_anim.play("Shockwave_comeback")
		time_stop()
		

func camera_follows_player():
	var player_pos: Vector3 = global_transform.origin
	camera_rig.global_transform.origin = player_pos

func rotate_camera(delta) -> void:
	if ui.is_shop_open:
		return
	if Input.is_action_pressed("rotate_camera_clockwise"):
		camera_rig.rotate_y(deg_to_rad(-camera_rotation_speed * delta)) 
	if Input.is_action_pressed("rotate_camera_counterclockwise"):
		camera_rig.rotate_y(deg_to_rad(camera_rotation_speed * delta)) 


func look_at_cursor():
	if is_time_warping:
		return
	
	# Create a horizontal plane, and find a point where the ray intersects with it
	var player_pos: Vector3 = global_transform.origin
	var dropPlane: Plane = Plane(Vector3(0, 1, 0), player_pos.y)
	# Project a ray from camera, from where the mouse cursor is in 2D viewport
	var ray_length: float = 1000
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from,to)
	
	if cursor_pos != null:
		cursor.global_transform.origin = cursor_pos + Vector3(0,0,0)
		# Make player look at the cursor
		look_at(cursor_pos, Vector3.UP)

func move_player(delta):
	if is_time_warping:
		return
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
	
func take_damage(damage: float, origin: Vector3):
	health -= damage
#	take_damage_emitter.look_at(origin)
#	take_damage_emitter.emitting = true
	var new_emitter: GPUParticles3D = take_damage_emitter.duplicate()
	add_child(new_emitter)
	new_emitter.look_at(origin)
	new_emitter.emitting = true
	await(new_emitter.finished)
	new_emitter.queue_free()
	
func get_current_magazine() -> int:
	return guns.get_current_magazine()

func get_magazine_size() -> int:
	return guns.get_magazine_size()
	
func get_magazines() -> int:
	return guns.get_magazines()
	
func reload():
	if not is_reloading:
		is_reloading = true
		guns.reload_current_weapon()
		
func reload_finished():
	is_reloading = false
	
func time_slow():
	Engine.time_scale = .5
	await(get_tree().create_timer(skill_time).timeout)
	Engine.time_scale = 1
	
func time_warp():
	is_time_warping = true
	Engine.time_scale = .4
	await(get_tree().create_timer(.4).timeout)
	var counter = time_warp_positions.size()
	while counter > 0:
		counter -= 1
		transform = time_warp_positions[counter]
		health = time_warp_hps[counter]
		await(get_tree().create_timer(.035).timeout)
	Engine.time_scale = 1
	is_time_warping = false
	
func add_time_warp_position():
	if is_time_warping:
		return
	time_warp_hps.push_back(health)
	time_warp_positions.push_back(transform)
	match time_warp_counter:
		1:
			$GhostMarkers/ghost_marker_1.transform = time_warp_positions.back()
		2:
			$GhostMarkers/ghost_marker_2.transform = time_warp_positions.back()
		3:
			$GhostMarkers/ghost_marker_3.transform = time_warp_positions.back()
		4:
			$GhostMarkers/ghost_marker_4.transform = time_warp_positions.back()
		5:
			$GhostMarkers/ghost_marker_5.transform = time_warp_positions.back()
		6:
			$GhostMarkers/ghost_marker_6.transform = time_warp_positions.back()
		7:
			$GhostMarkers/ghost_marker_7.transform = time_warp_positions.back()
		8:
			$GhostMarkers/ghost_marker_8.transform = time_warp_positions.back()
	time_warp_counter += 1
	if time_warp_counter > $GhostMarkers.get_child_count():
		time_warp_counter = 1
	if time_warp_positions.size() > $GhostMarkers.get_child_count():
		time_warp_positions.pop_front()
		time_warp_hps.pop_front()

func toggle_time_slow():
	if not is_time_slow_toggled:
		delta_modifier = 4
		Engine.time_scale = .5
		is_time_slow_toggled = true
	else:
		is_time_slow_toggled = false
		Engine.time_scale = 1
		delta_modifier = 1

func time_stop():
	EventBus.time_stop_start.emit(3)
	await(shockwave_anim.animation_finished)
	time_stop_cooldown_timer = time_stop_cooldown
	is_time_stop = false
	
func time_skill_effect():
	$Shockwave/ShockwaveAnim.play("Shockwave")

	
