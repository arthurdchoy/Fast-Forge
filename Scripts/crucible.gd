extends Area2D

enum CRUCIBLE_STATES {
	EMPTY,		## The crucible is empty.
	MELTING,	## The crucible is melting a metal.
	HOLDING,	## The crucible is idle with a molten metal.
	POURING		## The crucible is pouring a metal into an alloy basin.
}

const POUR_TIME : int = 2

signal crucibleClick()

@export var moltenTexture : TextureRect
@export var selectLines : Sprite2D
@export var arrowOfAvailability : Sprite2D
@export var timer : Timer
@export var progressBar : ProgressBar
@export var bloop1 : AudioStreamPlayer
@export var bloop2 : AudioStreamPlayer
@export var fireCrackle : AudioStreamPlayer
@export var pourSound : AudioStreamPlayer

var mouseOver = false
var pouringLeft = false
var pouringRight = false

var state : CRUCIBLE_STATES
var heldMetal : Metal

# Called when the node enters the scene tree for the first time.
func _ready():
	moltenTexture.visible = false
	selectLines.visible = false
	arrowOfAvailability.visible = false
	progressBar.visible = false
	mouseOver = false
	state = CRUCIBLE_STATES.EMPTY

func _process(_delta):
	progressBar.value = timer.time_left

# MOLTEN TEXTURE FUNCTIONS, CONTROLLED BY CRUCIBLE
func showMolten(color : Color):
	moltenTexture.modulate = color
	moltenTexture.visible = true

func hideMolten():
	moltenTexture.visible = false

# ARROW FUNCTIONS, CONTROLLED BY CONTROLLER
func showArrow():
	arrowOfAvailability.visible = true

func hideArrow():
	arrowOfAvailability.visible = false

# TIMER FUNCTIONS, CONTROLLED BY CRUCIBLE
func startTimer(time : int):
	progressBar.max_value = time
	progressBar.value = time
	timer.wait_time = progressBar.value
	progressBar.visible = true
	timer.start()

# SPOUT CONTROL FUNCTIONS, CONTROLLED BY CONTROLLER
func pourLeft():
	if $LeftSpout:
		pourSound.play()
		state = CRUCIBLE_STATES.POURING
		$LeftSpout.showMolten(moltenTexture.modulate)
		hideMolten()
		startTimer(POUR_TIME)
		pouringLeft = true

func stopLeft():
	if $LeftSpout:
		$LeftSpout.hideMolten()

func pourRight():
	if $RightSpout:
		pourSound.play()
		state = CRUCIBLE_STATES.POURING
		$RightSpout.showMolten(moltenTexture.modulate)
		hideMolten()
		startTimer(POUR_TIME)
		pouringRight = true

func stopRight():
	if $RightSpout:
		$RightSpout.hideMolten()

# MOUSE OVER AND INPUT SIGNALS, USED BY CONTROLLER
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
		crucibleClick.emit()

# CRUCIBLE INTERNAL STATE FUNCTIONS, INITIATED BY CONTROLLER
func meltMetal(m : Metal):
	state = CRUCIBLE_STATES.MELTING
	var temp = randi_range(0, 1)
	if temp == 0:
		bloop1.play()
	else:
		bloop2.play()
	fireCrackle.play()
	showMolten(m.color)
	startTimer(m.metalBaseMeltTimeInSeconds)
	heldMetal = m

func _on_timer_timeout():
	if state == CRUCIBLE_STATES.MELTING:
		fireCrackle.stop()
		state = CRUCIBLE_STATES.HOLDING
	elif state == CRUCIBLE_STATES.POURING:
		state = CRUCIBLE_STATES.EMPTY
		pourSound.stop()
		if pouringLeft: stopLeft()
		if pouringRight: stopRight()
	progressBar.visible = false

func cast():
	state = CRUCIBLE_STATES.EMPTY
	hideMolten()
	return heldMetal
