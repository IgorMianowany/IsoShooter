class_name Shotgun
extends Gun

var fire_rate : float = 1

@onready var gun_anim : AnimationPlayer = $AnimationPlayer
@onready var gun_barrel = $Barrel

func _process(delta: float) -> void:
	fire_rate -= delta

func _shoot():
	if !gun_anim.is_playing() and fire_rate <= 0:
		fire_rate = 1
		gun_anim.play("shoot")
		for child in gun_barrel.get_children():
			instance = bullet.instantiate()
			player.get_parent().add_child(instance)
			instance.damage = 1
			instance.global_position = child.global_position
			instance.transform.basis = child.global_transform.basis
