extends RayCast3D

var max_length : float = -45

@onready var laser_mesh = $LaserMesh




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		laser_mesh.mesh.height = abs(cast_point.y)
		laser_mesh.position.y = cast_point.y/2
	else:
		laser_mesh.mesh.height = max_length
		laser_mesh.position.y = max_length/2
		
	
