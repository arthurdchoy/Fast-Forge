extends Node2D

@export var moltenTexture : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	moltenTexture.visible = false

func showMolten(color : Color):
	moltenTexture.modulate = color
	moltenTexture.visible = true
	
func hideMolten():
	moltenTexture.visible = false
