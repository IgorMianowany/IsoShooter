class_name SkillIcon
extends Control

var progress : float
var max_progress : float = 1
@export var icon : CompressedTexture2D

func _ready() -> void:
	$Button/TextureProgressBar.max_value = max_progress 
	$Button.icon = icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Button/TextureProgressBar.value = progress
	$Button/TextureProgressBar.max_value = max_progress 
	
func toggle_fill_type(fillMode : TextureProgressBar.FillMode):
	$Button/TextureProgressBar.fill_mode = fillMode
