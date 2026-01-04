class_name Sniper
extends Gun

var fire_rate : float = 1

@onready var gun_anim : AnimationPlayer = $AnimationPlayer
@onready var gun_barrel = $RayCast3D

func _ready() -> void:
	magazine_size = 5
	magazines = 10
	bullet_pierce = 99
	super()

func _process(delta: float) -> void:
	fire_rate -= delta

func _shoot():
	if !gun_anim.is_playing() and fire_rate <= 0 and current_magazine > 0:
		current_magazine -= 1
		fire_rate = 1
		gun_anim.play("shoot")
		instance = bullet.instantiate()
		instance.damage = 100
		instance.pierce = bullet_pierce
		player.get_parent().add_child(instance)
		instance.global_position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
