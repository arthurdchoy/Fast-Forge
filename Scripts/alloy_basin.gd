extends Area2D

enum ALLOY_BASIN_STATES {
	EMPTY,		## The alloy basin is empty.
	MIXING,		## The alloy basin is mixing an alloy.
	HOLDING		## The alloy basin is idle with a molten alloy.
}

signal basinClick()

@export var leftMoltenTexture  : TextureRect
@export var rightMoltenTexture : TextureRect
@export var selectLines : Sprite2D
@export var timer : Timer
@export var progressBar : ProgressBar
@export var label : Label
@export var lavaBubble1 : AudioStreamPlayer
@export var lavaBubble2 : AudioStreamPlayer

var mouseOver : bool = false
var state : ALLOY_BASIN_STATES
var heldAlloy : Alloy

# Called when the node enters the scene tree for the first time.
func _ready():
	leftMoltenTexture.visible = false
	rightMoltenTexture.visible = false
	selectLines.visible = false
	mouseOver = false
	state = ALLOY_BASIN_STATES.EMPTY
	label.text = ""
	label.visible = false

func _process(_delta):
	progressBar.value = timer.time_left
	if state == ALLOY_BASIN_STATES.MIXING \
	or state == ALLOY_BASIN_STATES.HOLDING:
		if mouseOver:
			label.text = heldAlloy.name
			label.visible = true
		else: 
			label.visible = false
	else: 
		label.visible = false

func showMolten(leftColor : Color, rightColor : Color):
	leftMoltenTexture.modulate = leftColor
	rightMoltenTexture.modulate = rightColor
	leftMoltenTexture.visible = true
	rightMoltenTexture.visible = true
	
func hideMolten():
	leftMoltenTexture.visible = false
	rightMoltenTexture.visible = false

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
			basinClick.emit()

func startTimer(time : int):
	var temp = randi_range(0, 1)
	if temp == 0:
		lavaBubble1.play()
	else:
		lavaBubble2.play()
	progressBar.max_value = time
	progressBar.value = time
	timer.wait_time = progressBar.value
	progressBar.visible = true
	timer.start()

func mixMetal(m1 : Metal, m2 : Metal, a : Alloy):
	state = ALLOY_BASIN_STATES.MIXING
	showMolten(m1.color, m2.color)
	print("Alloy: " + a.name + " | Mix Time: " + str(a.calculate_mix_time()))
	startTimer(a.calculate_mix_time())
	heldAlloy = a

func _on_timer_timeout():
	if state == ALLOY_BASIN_STATES.MIXING:
		state = ALLOY_BASIN_STATES.HOLDING
		if lavaBubble1.playing: lavaBubble1.stop()
		else: lavaBubble2.stop()
		showMolten(heldAlloy.color, heldAlloy.color)

func cast():
	state = ALLOY_BASIN_STATES.EMPTY
	hideMolten()
	return heldAlloy
