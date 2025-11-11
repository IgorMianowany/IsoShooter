class_name Bullet
extends Node3D

var speed : float = 40
var lifetime_timer : Timer = Timer.new()

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var emitter: GPUParticles3D = $GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(lifetime_timer)
	lifetime_timer.connect("timeout", on_lifetime_timeout)
	lifetime_timer.start(2)

func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -speed) * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ray.is_colliding():
		mesh.visible = false
		emitter.emitting = true
		ray.enabled = false
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit()
		await emitter.finished
		queue_free()

func on_lifetime_timeout():
	queue_free()
		

		
