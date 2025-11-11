class_name Enemy
extends CharacterBody3D


const SPEED : float = 10
const JUMP_VELOCITY = 4.5
var health = 100

var player : Player


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if player != null:
		var direction := global_position.direction_to(player.global_position)
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
	

	move_and_slide()


func _on_area_3d_body_part_hit(damage: Variant) -> void:
	health -= damage / 10
	if health <= 0:
		queue_free()


func _on_aggro_range_area_entered(area: Area3D) -> void:
	player = area.get_parent()
