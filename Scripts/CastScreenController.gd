extends Node

signal sendPartUp(p : Part)

@export var partTextures : Array[Texture2D] = []
@export var clickSound : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	for cast in $Casts.get_children():
		cast.connect("castFinish", collectPart)

func placeCast(m : Base, c : Cast):
	for cast in $Casts.get_children():
		if cast.state == cast.CAST_STATES.EMPTY:
			cast.getCast(m, c)
			return

func collectPart(p : Part):
	clickSound.play()
	sendPartUp.emit(p)
