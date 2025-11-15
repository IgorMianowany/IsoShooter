class_name Enemy
extends CharacterBody3D


var speed : float = 500
const JUMP_VELOCITY = 4.5
var health = 10
var pursue_cooldown : float = 0
var player : Player
var next_nav_position : Vector3
var new_velocity : Vector3
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if player != null:
		velocity = Vector3.ZERO
		if pursue_cooldown <= 0:
			nav_agent.set_target_position(player.global_transform.origin)
			next_nav_position = nav_agent.get_next_path_position()
			#velocity = global_position.direction_to(next_nav_position) * speed * delta
			#new_velocity = (next_nav_position - global_position).normalized() * speed * delta
			new_velocity = velocity.move_toward(next_nav_position - global_position, 10 * delta).normalized() * speed * delta
			pursue_cooldown = .5

		velocity = new_velocity
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
		
	move_and_slide()
	
func _process(delta: float) -> void:
	pursue_cooldown -= delta


func _on_area_3d_body_part_hit(damage: Variant) -> void:
	health -= damage / 10
	if health <= 0:
		queue_free()


func _on_aggro_range_area_entered(area: Area3D) -> void:
	player = area.get_parent()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
