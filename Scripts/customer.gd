extends Node2D

signal timeOver()

enum ELEMENT {
	FIRE,		## Fire element 
	LIGHT, 		## Light/Holy element
	ICE, 		## Ice element
	PHYSICAL	## Physical/Neutral element, should not be attached to any alloy or metal directly
}
enum ORDER_TYPE {
	ELEMENT,
	WEIGHT_UNDER,
	WEIGHT_OVER,
	COMPONENTS
}

@export var baseOrder : Order
@export var possibleLooks : Array[Texture2D] = []
@export var look : Sprite2D
@export var possibleNames : Array[String] = []
var customerName : String
var orderTime : int
var customerID : int
@export var nameLabel : Label
@export var weaponTypeLabel : Label
@export var requirementsLabel : Label
@export var patienceTimer : Timer
@export var patienceBar : ProgressBar
@export var jingle : AudioStreamPlayer

func initializeCustomer(temp : int):
	jingle.play()
	look.texture = possibleLooks[temp]
	customerName = possibleNames[temp]
	customerID = temp
	orderTime = 0

func addGraceTime(time : int):
	orderTime += time

func startOrder(w : Weapon):
	baseOrder.determineRequirement(w)
	orderTime += baseOrder.time
	patienceBar.max_value = orderTime
	patienceBar.value = orderTime
	patienceTimer.wait_time = orderTime
	patienceTimer.start()
	nameLabel.text = "For " + customerName
	weaponTypeLabel.text = "Need " + baseOrder.orderWeapon.baseWeaponName
	requirementsLabel.text = "Requirements:"
	match baseOrder.type:
		ORDER_TYPE.ELEMENT:
			print("Order type: element")
			match baseOrder.requirement:
				ELEMENT.FIRE:
					requirementsLabel.text += "\n- Fire"
				ELEMENT.LIGHT:
					requirementsLabel.text += "\n- Light"
				ELEMENT.ICE:
					requirementsLabel.text += "\n- Ice"
				ELEMENT.PHYSICAL:
					requirementsLabel.text += "\n- Physical"
		ORDER_TYPE.WEIGHT_UNDER:
			print("Order type: weight under")
			requirementsLabel.text += "\n- under " + str(baseOrder.requirement) + " ingots"
		ORDER_TYPE.WEIGHT_OVER:
			print("Order type: weight over")
			requirementsLabel.text += "\n- over " + str(baseOrder.requirement) + " ingots"
		ORDER_TYPE.COMPONENTS:
			print("Order type: components")
			for n in baseOrder.requirement:
				requirementsLabel.text += "\n- Part that is " + n.name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	patienceBar.value = patienceTimer.time_left

func _on_patience_timer_timeout():
	print("customer timeOver emit")
	timeOver.emit()
