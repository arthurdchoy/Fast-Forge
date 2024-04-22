extends Node2D

var currentPages = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	currentPages = 0

func _process(_delta):
	if currentPages == 0:
		$LeftButton.disabled = true
	else:
		$LeftButton.disabled = false
	if currentPages == 22:
		$RightButton.disabled = true
	else:
		$RightButton.disabled = false

func disableButtons(i : bool):
	$LeftButton.disabled = i
	$RightButton.disabled = i

func _on_left_button_pressed():
	$Pages.translate(Vector2i(1024, 0))
	currentPages -= 1

func _on_right_button_pressed():
	$Pages.translate(Vector2i(-1024, 0))
	currentPages += 1
