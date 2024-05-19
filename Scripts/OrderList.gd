extends VBoxContainer

@export var customerLooks : Array[Texture2D] = []
var orderPositions : Array[bool] = [false, false, false, false]

# Called when the node enters the scene tree for the first time.
func _ready():
	refreshOrderList()

func refreshOrderList():
	$CustomerSelect.visible = orderPositions[0]
	$CustomerSelect/Button.disabled = !orderPositions[0]
	$CustomerSelect2.visible = orderPositions[1]
	$CustomerSelect2/Button.disabled = !orderPositions[1]
	$CustomerSelect3.visible = orderPositions[2]
	$CustomerSelect3/Button.disabled = !orderPositions[2]
	$CustomerSelect4.visible = orderPositions[3]
	$CustomerSelect4/Button.disabled = !orderPositions[3]

func getOrder(customerID : int, order : Order, pos : int):
	orderPositions[pos] = true
	match pos:
		0:
			$CustomerSelect.texture = customerLooks[customerID]
			$CustomerSelect.customerID = customerID
			$CustomerSelect.order = order
		1:
			$CustomerSelect2.texture = customerLooks[customerID]
			$CustomerSelect2.customerID = customerID
			$CustomerSelect2.order = order
		2:
			$CustomerSelect3.texture = customerLooks[customerID]
			$CustomerSelect3.customerID = customerID
			$CustomerSelect3.order = order
		3:
			$CustomerSelect4.texture = customerLooks[customerID]
			$CustomerSelect4.customerID = customerID
			$CustomerSelect4.order = order
	refreshOrderList()

func removeCustomer(id : int):
	if $CustomerSelect.customerID == id:
		orderPositions[0] = false
	elif $CustomerSelect2.customerID == id:
		orderPositions[1] = false
	elif $CustomerSelect.customerID == id:
		orderPositions[2] = false
	elif $CustomerSelect2.customerID == id:
		orderPositions[3] = false
	
	refreshOrderList()
