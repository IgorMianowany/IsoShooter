class_name Rifle
extends Gun

@onready var gun_anim : AnimationPlayer = $SteampunkRifle/AnimationPlayer
@onready var gun_barrel = $RayCast3D

func _ready() -> void:
	magazines = 6
	magazine_size = 30
	super()

func _shoot():
	if !gun_anim.is_playing() and current_magazine > 0:
		current_magazine -= 1
		gun_anim.play("shoot")
		instance = bullet.instantiate()
		player.get_parent().add_child(instance)
		instance.global_position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
