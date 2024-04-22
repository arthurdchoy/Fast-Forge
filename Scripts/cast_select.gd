extends Area2D

signal castClick(sendCast)

@export var cast : Cast
@export var selectLines : Sprite2D
@export var castSprite : Sprite2D

var mouseOver = false

func _ready():
	selectLines.visible = false
	# I'm gonna hurl
	castSprite.texture = cast.sprite
	$Label.text = cast.castName
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
		castClick.emit(cast)
