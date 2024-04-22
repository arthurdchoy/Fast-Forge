extends Node2D

signal startTheGame()

@export var clickSound : AudioStreamPlayer

func _on_button_pressed():
	clickSound.play()
	startTheGame.emit()
