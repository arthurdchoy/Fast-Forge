extends Node2D

# Variables
## The current metal in the crucible. If there is no metal, has the "nothing metal".
@export var currentMetal : Metal
## DO NOT CHANGE. This is meant to be a generic empty instance for when there is no metal currently in the crucible.
## I have no damn clue how I'm supposed to do something like this and I don't have the time to figure out.
@export var nothingMetal : Metal

## Timer that tracks how long until a metal melts
@export var meltTimer : Timer
## Timer that tracks how long to have the crucible pour its metal into a alloy basin.
## Time is constant. The time will be passed in as a constant through the controller node.
@export var pourTimer : Timer

@export var enableLeft  : bool
@export var enableRight : bool

# For the input button to show, these conditions must be true:
#	1. There is currently NO metal held in the crucible
#	2. The crucible is not actively pouring a metal

# For the pour buttons to show, these conditions must be true:
#	1. There is currently a metal held in the crucible
#	2. The metal must be molten
#	3. The crucible is not actively pouring a metal
#	4. The below alloy basin must be available
#		- The below basin will somehow communicate that it is available, either via
#		  signal or via a read variable. Either way, button only shows based on
#		  which basin is available

# For the dump button to show, these conditions must be true:
#	1. There is currently a metal held in the crucible
#	2. The metal must be molten
#	3. The crucible is not actively pouring the metal
#	In essence, the same conditions as pouring must be true, with the exception of alloy basin interactions

# Funny flags
## Indicates whether or not the crucible is actively holding a metal, molten or not.
## If true, Input is locked
## Becomes true when a metal is inputted.
## Becomes false when the currently held metal is poured, dumped, or cast
var holdingMetal : bool # Fulfills criteria 1. of Input, Pour, and Dump
## Indicates whether or not the crucible is currently melting a metal.
## If true, Input, Pour, and Dump are locked.
## Becomes true when a metal is inputted and the melt timer is activated.
## Becomes false when the melt timer finishes.
var meltLock : bool
## Indicates whether or not the crucible is currently pouring a metal.
## If true, Input, Pour, and Dump are locked.
## Becomes true when either of the pour buttons are pressed.
## Becomes false when the pour timer finishes.
var pourLock : bool

# Note: To standardize logic, all metals, alloys, parts, etc. will be GIVEN to the
# receiving node. The receiving node will make a function call and get the thing in return.

# Called when the node enters the scene tree for the first time.
func _ready():
	pourLock = false
	meltLock = false
	holdingMetal = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func melt_metal(inputMetal : Metal):
	pass

func pour_left(time : int):
	if !pourLock and !meltLock and holdingMetal:
		pourLock = true
		var removeMetal = currentMetal
		currentMetal = nothingMetal
		pourTimer.start(2)
		return removeMetal
	return nothingMetal # In theory, this should never be reached
	
func pour_right():
	if !pourLock and !meltLock and holdingMetal:
		pourLock = true
		var removeMetal = currentMetal
		currentMetal = nothingMetal
		pourTimer.start(2)
		return removeMetal
	return nothingMetal # In theory, this should never be reached

func show_buttons():
	pass

func _on_pour_timer_timeout():
	pourLock = false
	show_buttons()
