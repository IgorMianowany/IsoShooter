class_name Shotgun
extends Gun

var fire_rate : float = 1

@onready var gun_anim : AnimationPlayer = $AnimationPlayer
@onready var gun_barrel = $RayCast3D

func _process(delta: float) -> void:
	fire_rate -= delta

func _shoot():
	if !gun_anim.is_playing() and fire_rate <= 0:
		fire_rate = 1
		gun_anim.play("shoot")
		instance = bullet.instantiate()
		player.get_parent().add_child(instance)
		instance.damage = 5
		instance.global_position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
