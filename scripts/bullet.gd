class_name Bullet
extends Node3D

var speed : float = 70
var lifetime : float = 3 
var damage : float = 1
var pierce : int = 0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var emitter: GPUParticles3D = $GPUParticles3D

func _physics_process(delta: float) -> void:
	delta = (delta * EventBus.delta_modifier_non_player)
	lifetime -= delta
	if lifetime < 0:
		on_lifetime_timeout()
	position += transform.basis * Vector3(0, 0, -speed) * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ray.is_colliding():
		pierce -= 1
		if pierce < 0:
			emitter.emitting = true
			mesh.visible = false
			ray.enabled = false
		if ray != null and ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit(damage)
		await emitter.finished
		if pierce < 0:
			queue_free()

func on_lifetime_timeout():
	queue_free()
		

		
