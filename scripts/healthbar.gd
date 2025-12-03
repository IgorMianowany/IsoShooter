class_name Healthbar
extends Control

var timer : float = 0.5

@onready var healthbar := $Healthbar
@onready var shadowbar := $Shadowbar

func init_healthbars(value : float):
	healthbar.value = value
	healthbar.max_value = value
	shadowbar.value = value
	shadowbar.max_value = value
	
func take_damage(new_health : float):
	healthbar.value = new_health
	timer = .5
	
	
func _process(delta: float) -> void:
	timer -= delta
	if shadowbar.value > healthbar.value and timer <= 0:
		shadowbar.value -= delta * 15
