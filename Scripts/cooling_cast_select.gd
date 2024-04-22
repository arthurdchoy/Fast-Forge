extends Node2D

signal castFinish(p : Part)

enum CAST_STATES {
	EMPTY,
	COOLING,
	HOLDING
}
enum PART_TYPES {
	BLADE,
	HANDLE,
	CROSSGUARD,
	PLATE,
	BRICK
}

@export var castTemplate : Sprite2D
@export var timer : Timer
@export var progressBar : ProgressBar
@export var partTextures : Array[Texture2D] = []
@export var partSprite : Sprite2D
@export var partNameLabel : Label

var heldCast : Cast
var castMaterial : Base
var state : CAST_STATES
var p : Part

# Called when the node enters the scene tree for the first time.
func _ready():
	castTemplate.visible = false
	partSprite.visible = false
	partNameLabel.visible = false
	progressBar.visible = false
	state = CAST_STATES.EMPTY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	progressBar.value = timer.time_left

func startTimer(time : int):
	progressBar.max_value = time
	progressBar.value = time
	timer.wait_time = progressBar.value
	progressBar.visible = true
	timer.start()

func castToPart(m : Base, c : Cast):
	p = Part.new()
	p.partMaterial = m
	match c.castType:
		c.CAST_TYPE.BLADE:
			p.type = p.PART_TYPE.BLADE
		c.CAST_TYPE.HANDLE:
			p.type = p.PART_TYPE.HANDLE
		c.CAST_TYPE.CROSSGUARD:
			p.type = p.PART_TYPE.CROSSGUARD
		c.CAST_TYPE.PLATE:
			p.type = p.PART_TYPE.PLATE
		c.CAST_TYPE.BRICK:
			p.type = p.PART_TYPE.BRICK
	p.partName = m.name + " " + c.castName
	p.texture = partTextures[p.type]

func getCast(m : Base, c : Cast):
	var temp : float
	castMaterial = m
	heldCast = c
	castToPart(m, c)
	partSprite.texture = p.texture
	partSprite.modulate = p.partMaterial.color
	partNameLabel.text = p.partName
	castTemplate.visible = true
	partSprite.visible = true
	partNameLabel.visible = true
	if m is Metal:
		state = CAST_STATES.COOLING
		temp = (float(m.metalBaseMeltTimeInSeconds)/2) * c.coolingMultiplier
		progressBar.visible = true
		startTimer(temp)
	elif m is Alloy:
		state = CAST_STATES.COOLING
		temp = (float(m.calculate_mix_time())/2) * c.coolingMultiplier
		progressBar.visible = true
		startTimer(temp)

func _on_button_pressed():
	if state == CAST_STATES.HOLDING:
		state = CAST_STATES.EMPTY
		castTemplate.visible = false
		partSprite.visible = false
		partNameLabel.visible = false
		print("Cooled cast has been clicked")
		castFinish.emit(p)

func _on_timer_timeout():
	state = CAST_STATES.HOLDING
	progressBar.visible = false
