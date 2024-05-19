extends Node2D

signal removeCustomer(i : int)

@export var orderList : VBoxContainer
@export var weaponRack : GridContainer
@export var weaponDesc : VBoxContainer
@export var selectedCustomerLabel : Label
@export var fulfillOrderButton : Button
@export var potentialCustomerNames : Array[String]
@export var clickSound : AudioStreamPlayer

var selectedCustomer : int = -1
var selectedCustomerOrder : Order
var selectedWeapon : Weapon
var selectingCustomer : bool = false
var selectingWeapon : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	selectingCustomer = false
	selectingWeapon = false
	fulfillOrderButton.visible = false
	fulfillOrderButton.disabled = true
	for n in $HBoxContainer/OrderList/VBoxContainer.get_children():
		n.connect("selected", customerSelected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	selectedCustomerLabel.visible = selectingCustomer
	if selectingCustomer and selectingWeapon:
		fulfillOrderButton.visible = true
		if selectedCustomerOrder.checkRequirements(selectedWeapon):
			fulfillOrderButton.disabled = false
			fulfillOrderButton.text = "Weapon meets requirements!"
		else:
			fulfillOrderButton.disabled = true
			fulfillOrderButton.text = "Weapon doesn't meet requirements!"
	else:
		fulfillOrderButton.visible = false
		fulfillOrderButton.disabled = true

func receiveOrder(id : int, o : Order, pos : int):
	$HBoxContainer/OrderList/VBoxContainer.getOrder(id, o, pos)

func receiveWeapon(w : Control):
	w.setVisible(true)
	w.disableButton(false)
	print("weapon received: " + w.weapon.baseWeaponName)
	weaponRack.add_child(w)
	w.connect("sendWeaponUp", weaponSelected)

func showWeaponDetails(w : Weapon):
	weaponDesc.setLabels(w)
	weaponDesc.showLabels()

func hideWeaponDetails():
	weaponDesc.hideLabels()

func customerSelected(id : int, o : Order):
	clickSound.play()
	print("customer selected")
	if id == selectedCustomer:
		print("customer selection cancelled")
		selectedCustomer = -1
		selectingCustomer = false
		return
	selectingCustomer = true
	selectedCustomer = id
	selectedCustomerOrder = o
	selectedCustomerLabel.text = "Selected:\n" + potentialCustomerNames[id]

func weaponSelected(w : Control):
	clickSound.play()
	if w.weapon == selectedWeapon:
		selectedWeapon = null
		selectingWeapon = false
		hideWeaponDetails()
		return
	selectedWeapon = w.weapon
	selectingWeapon = true
	showWeaponDetails(w.weapon)

func _on_button_pressed():
	clickSound.play()
	orderList.removeCustomer(selectedCustomer)
	for n in $HBoxContainer/WeaponRack/GridContainer.get_children():
		if n.weapon == selectedWeapon:
			$HBoxContainer/WeaponRack/GridContainer.remove_child(n)
			n.queue_free()
	selectingCustomer = false
	selectingWeapon = false
	hideWeaponDetails()
	removeCustomer.emit(selectedCustomer)
	
