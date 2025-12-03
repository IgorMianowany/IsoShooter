class_name Enemy
extends CharacterBody3D


var speed : float = 500
const JUMP_VELOCITY = 4.5
var health = 10
var pursue_cooldown : float = 0
var pursue_cooldown_max : float = 1
var player : Player
var next_nav_position : Vector3
var new_velocity : Vector3
var previous_position : Vector3
var look_at_pos = Vector3.ZERO
var look_toward_pos = Vector3.ZERO
var is_attacking : bool = false
var is_idle : bool = true
var is_reaction : bool = false
var is_hard_reaction : bool = false

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var healthbar = $SubViewport/Healthbar

func _ready() -> void:
	healthbar.init_healthbars(health)
	previous_position = global_position
	nav_agent.avoidance_priority = 1 - randf_range(0, 0.4)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if player != null:
		velocity = Vector3.ZERO
		if pursue_cooldown <= 0:
			nav_agent.set_target_position(player.global_transform.origin)
			next_nav_position = nav_agent.get_next_path_position()
			new_velocity = velocity.move_toward(next_nav_position - global_position, 10 * delta).normalized() * speed * delta
			pursue_cooldown = pursue_cooldown_max

		velocity = new_velocity
		look_at_pos = global_position + velocity
		look_toward_pos = look_toward_pos.move_toward(Vector3(look_at_pos.x, global_position.y + 5, look_at_pos.z), delta * 30)
		# look at movement direction
		if look_toward_pos.x != global_position.x or look_toward_pos.z != global_position.z:
			look_at(Vector3(look_toward_pos.x, global_position.y, look_toward_pos.z))
		# look at player
		#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
	move_and_slide()
	
func _process(delta: float) -> void:
	pursue_cooldown -= delta


func _on_area_3d_body_part_hit(damage: Variant) -> void:
	var reaction_roll = randf_range(0,1)
	if reaction_roll >= .9:
		speed = 0
		if reaction_roll > .975: 
			is_hard_reaction = true
		else:
			is_reaction = true 
	health -= damage / 10
	healthbar.take_damage(health)
	if health <= 0:
		EventBus.enemy_count -= 1
		queue_free()


func _on_aggro_range_area_entered(area: Area3D) -> void:
	player = area.get_parent()
	is_idle = false


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("Reaction"):
		speed = 500
		is_reaction = false
		is_hard_reaction = false
