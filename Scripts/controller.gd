extends Node

@export var bgm : AudioStreamPlayer
@export var gameOverMusic : AudioStreamPlayer
@export var guidebook : Node2D
@export var guidebookButton : Button

var currentScreen = 0
var customersServed = 0
var guidebookOpen = false
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	currentScreen = 0
	customersServed = 0
	guidebook.disableButtons(true)
	guidebook.visible = false
	guidebookOpen = false
	started = false

func openGuidebook():
	if not guidebookOpen:
		guidebook.visible = true
		guidebook.disableButtons(false)
		$LeftButton.disabled = true
		$LeftButton.visible = false
		$RightButton.disabled = true
		$RightButton.visible = false
		if not started:
			$Screens/StartScreen/Button.disabled = true
	else:
		guidebook.visible = false
		guidebook.disableButtons(true)
		$LeftButton.disabled = false
		$LeftButton.visible = true
		$RightButton.disabled = false
		$RightButton.visible = true
		if not started:
			$Screens/StartScreen/Button.disabled = false
	guidebookOpen = !guidebookOpen

func start():
	bgm.playing = true
	started = true
	$Screens/StartScreen.translate(Vector2i(0, 1000))
	$Screens/CrucibleScreen.start()
	$Screens/CounterScreen.start()

func _send_cast_down(mOrA, c):
	$Screens/CastScreen.placeCast(mOrA, c)

func _send_part_down(p):
	$Screens/AssemblyScreen.receivePart(p)

func _send_weapon_down(w):
	print("sent weapon up, weight: " + str(w.weapon.getWeaponWeight()))
	$Screens/WeaponRack.receiveWeapon(w)

# Button Functions
func _on_right_button_pressed():
	if currentScreen == 4:
		$Screens.translate(Vector2i(4096, 0))
		currentScreen = 0
	else:
		$Screens.translate(Vector2i(-1024, 0))
		currentScreen += 1

func _on_left_button_pressed():
	if currentScreen == 0:
		$Screens.translate(Vector2i(-4096, 0))
		currentScreen = 4
	else:
		$Screens.translate(Vector2i(1024, 0))
		currentScreen -= 1

func _on_weapon_rack_remove_customer(i):
	$Screens/CounterScreen.customerServed(i)

func _on_counter_screen_customer_serve_success():
	customersServed += 1

func _on_counter_screen_customer_arrive(id, o, pos):
	$Screens/WeaponRack.receiveOrder(id, o, pos)

func gameOver():
	started = false
	$Screens/CrucibleScreen.stop()
	$Screens/CounterScreen.stop()
	$RightButton.visible = false
	$RightButton.disabled = true
	$LeftButton.visible = false
	$LeftButton.disabled = true
	$GameOverSprite/Label.text = str(customersServed)
	$GameOverSprite.visible = true
	guidebookButton.visible = false
	guidebookButton.disabled = true
	bgm.stop()
	gameOverMusic.play()
	
