extends Area2D

signal metalClick(sendMetal)

@export var metal : Metal
@export var selectLines : Sprite2D

var mouseOver = false

func _ready():
	selectLines.visible = false
	$Bar.modulate = metal.color
	$Label.text = metal.name
	mouseOver = false

func _on_mouse_shape_entered(_shape_idx):
	selectLines.visible = true
	mouseOver = true

func _on_mouse_shape_exited(_shape_idx):
	selectLines.visible = false
	mouseOver = false

func _input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed and mouseOver:
			metalClick.emit(metal)
