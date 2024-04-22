extends Node

var started : bool = false

signal sendCastUp(mOrA : Base, c : Cast)

enum CRUCIBLE_STATES {
	EMPTY,		## The crucible is empty.
	MELTING,	## The crucible is melting a metal.
	HOLDING,	## The crucible is idle with a molten metal.
	POURING		## The crucible is pouring a metal into an alloy basin.
}
enum ALLOY_BASIN_STATES {
	EMPTY,		## The alloy basin is empty.
	MIXING,		## The alloy basin is mixing an alloy.
	HOLDING		## The alloy basin is idle with a molten alloy.
}

var isSelectingMetal : bool = false
var selectedMetal : Metal
var isSelectingCast : bool = false
var selectedCast : Cast

@export var metalsButton : Button
@export var castsButton : Button

@export var crucibles : Array[Node2D] = []
@export var alloyBasins : Array[Node2D] = []

@export var alloyList : Array[Alloy] = []

@export var clickSound : AudioStreamPlayer

var currentCasts : int

# Called when the node enters the scene tree for the first time.
func _ready():
	started = false
	isSelectingMetal = false
	isSelectingCast = false
	metalsButton.disabled = true
	currentCasts = 0
	for temp in $Metals.get_children():
		temp.connect("metalClick", _metal_click)
	for temp in $Casts.get_children():
		temp.connect("castClick", _cast_click)

func start():
	started = true

func stop():
	started = false

func _process(_delta):
	if isSelectingMetal:
		showCrucibleArrows()
	else:
		hideCrucibleArrows()

func _crucible_1_click():
	print("Click on crucible 1")
	clickSound.play()
	if crucibles[0].state == CRUCIBLE_STATES.EMPTY:
		if isSelectingMetal:
			var temp = selectedMetal
			isSelectingMetal = false
			crucibles[0].meltMetal(temp)
	if crucibles[0].state == CRUCIBLE_STATES.HOLDING:
		if isSelectingCast:
			if currentCasts < 14:
				if selectedCast.castType == Cast.CAST_TYPE.DELETE:
					isSelectingCast = false
					crucibles[0].cast()
				else:
					isSelectingCast = false
					sendCastUp.emit(crucibles[0].cast(), selectedCast)
					currentCasts += 1
			else:
				isSelectingCast = false
			

func _crucible_2_click():
	print("Click on crucible 2")
	clickSound.play()
	if crucibles[1].state == CRUCIBLE_STATES.EMPTY:
		if isSelectingMetal:
			var temp = selectedMetal
			isSelectingMetal = false
			crucibles[1].meltMetal(temp)
	if crucibles[1].state == CRUCIBLE_STATES.HOLDING:
		if isSelectingCast:
			if currentCasts < 14:
				if selectedCast.castType == Cast.CAST_TYPE.DELETE:
					isSelectingCast = false
					crucibles[1].cast()
				else:
					isSelectingCast = false
					sendCastUp.emit(crucibles[1].cast(), selectedCast)
					currentCasts += 1
			else:
				isSelectingCast = false

func _crucible_3_click():
	print("Click on crucible 3")
	clickSound.play()
	if crucibles[2].state == CRUCIBLE_STATES.EMPTY:
		if isSelectingMetal:
			var temp = selectedMetal
			isSelectingMetal = false
			crucibles[2].meltMetal(temp)
	if crucibles[2].state == CRUCIBLE_STATES.HOLDING:
		if isSelectingCast:
			if currentCasts < 14:
				if selectedCast.castType == Cast.CAST_TYPE.DELETE:
					isSelectingCast = false
					crucibles[2].cast()
				else:
					isSelectingCast = false
					sendCastUp.emit(crucibles[2].cast(), selectedCast)
					currentCasts += 1
			else:
				isSelectingCast = false

func _crucible_4_click():
	print("Click on crucible 4")
	clickSound.play()
	if crucibles[3].state == CRUCIBLE_STATES.EMPTY:
		if isSelectingMetal:
			var temp = selectedMetal
			isSelectingMetal = false
			crucibles[3].meltMetal(temp)
	if crucibles[3].state == CRUCIBLE_STATES.HOLDING:
		if isSelectingCast:
			if currentCasts < 14:
				if selectedCast.castType == Cast.CAST_TYPE.DELETE:
					isSelectingCast = false
					crucibles[3].cast()
				else:
					isSelectingCast = false
					sendCastUp.emit(crucibles[3].cast(), selectedCast)
					currentCasts += 1
			else:
				isSelectingCast = false

func _basin_1_click():
	clickSound.play()
	if alloyBasins[0].state == ALLOY_BASIN_STATES.EMPTY:
		if crucibles[0].state == CRUCIBLE_STATES.HOLDING \
		and crucibles[1].state == CRUCIBLE_STATES.HOLDING:
			var m1 = crucibles[0].heldMetal
			var m2 = crucibles[1].heldMetal
			var temp = checkAlloys(m1, m2)
			if temp:
				crucibles[0].pourRight()
				crucibles[1].pourLeft()
				alloyBasins[0].mixMetal(m1, m2, temp)
			else:
				print("Not a valid alloy!")
	if alloyBasins[0].state == ALLOY_BASIN_STATES.HOLDING:
		if isSelectingCast:
			if currentCasts < 14:
				if selectedCast.castType == Cast.CAST_TYPE.DELETE:
					isSelectingCast = false
					alloyBasins[0].cast()
				else:
					isSelectingCast = false
					sendCastUp.emit(alloyBasins[0].cast(), selectedCast)
					currentCasts += 1
			else:
				isSelectingCast = false

func _basin_2_click():
	clickSound.play()
	if alloyBasins[1].state == ALLOY_BASIN_STATES.EMPTY:
		if crucibles[1].state == CRUCIBLE_STATES.HOLDING \
		and crucibles[2].state == CRUCIBLE_STATES.HOLDING:
			var m1 = crucibles[1].heldMetal
			var m2 = crucibles[2].heldMetal
			var temp = checkAlloys(m1, m2)
			if temp:
				crucibles[1].pourRight()
				crucibles[2].pourLeft()
				alloyBasins[1].mixMetal(m1, m2, temp)
			else:
				print("Not a valid alloy!")
	if alloyBasins[1].state == ALLOY_BASIN_STATES.HOLDING:
		if isSelectingCast:
			if currentCasts < 14:
				if selectedCast.castType == Cast.CAST_TYPE.DELETE:
					isSelectingCast = false
					alloyBasins[1].cast()
				else:
					isSelectingCast = false
					sendCastUp.emit(alloyBasins[1].cast(), selectedCast)
					currentCasts += 1
			else:
				isSelectingCast = false

func _basin_3_click():
	clickSound.play()
	if alloyBasins[2].state == ALLOY_BASIN_STATES.EMPTY:
		if crucibles[2].state == CRUCIBLE_STATES.HOLDING \
		and crucibles[3].state == CRUCIBLE_STATES.HOLDING:
			var m1 = crucibles[2].heldMetal
			var m2 = crucibles[3].heldMetal
			var temp = checkAlloys(m1, m2)
			if temp:
				crucibles[2].pourRight()
				crucibles[3].pourLeft()
				alloyBasins[2].mixMetal(m1, m2, temp)
			else:
				print("Not a valid alloy!")
	if alloyBasins[2].state == ALLOY_BASIN_STATES.HOLDING:
		if isSelectingCast:
			if currentCasts < 14:
				if selectedCast.castType == Cast.CAST_TYPE.DELETE:
					isSelectingCast = false
					alloyBasins[2].cast()
				else:
					isSelectingCast = false
					sendCastUp.emit(alloyBasins[2].cast(), selectedCast)
					currentCasts += 1
			else:
				isSelectingCast = false

# CRUCIBLE ARROW FUNCTIONS
func showCrucibleArrows():
	for c in crucibles:
		if c.state == CRUCIBLE_STATES.EMPTY:
			c.showArrow()

func hideCrucibleArrows():
	for c in crucibles:
		c.hideArrow()

# ALLOY CHECK FUNCTION
func checkAlloys(m1 : Metal, m2 : Metal):
	for alloy in alloyList:
		if m1 == alloy.alloyComponent1 and m2 == alloy.alloyComponent2 \
		or m1 == alloy.alloyComponent2 and m2 == alloy.alloyComponent1:
			return alloy
	return null

# CRUCIBLE INPUT FUNCTIONS
func _metal_click(m : Metal):
	if started:
		clickSound.play()
		isSelectingCast = false
		isSelectingMetal = true
		selectedMetal = m

func _cast_click(c : Cast):
	if started:
		clickSound.play()
		isSelectingCast = true
		isSelectingMetal = false
		selectedCast = c

func _input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed and isSelectingMetal:
		isSelectingMetal = false
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed and isSelectingCast:
		isSelectingCast = false

func _on_metals_button_pressed():
	clickSound.play()
	metalsButton.disabled = true
	castsButton.disabled = false
	$Metals.translate(Vector2(0, -200))
	$Casts.translate(Vector2(0, 200))

func _on_casts_button_pressed():
	clickSound.play()
	castsButton.disabled = true
	metalsButton.disabled = false
	$Casts.translate(Vector2(0, -200))
	$Metals.translate(Vector2(0, 200))
