extends Control

signal selected(s : Control)

@export var sprite : Sprite2D
@export var button : Button
@export var label : Label

var p : Part

func _ready():
	pass
	#sprite.visible = false
	#label.visible = false
	#button.disabled = true

func getPart(input : Part):
	print("Received " + input.partName)
	p = input
	sprite.texture = p.texture
	sprite.modulate = p.partMaterial.color
	sprite.visible = true
	label.text = p.partName
	label.visible = true
	button.disabled = false

func _on_button_pressed():
	selected.emit(self)
