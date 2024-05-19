extends Node2D

signal customerArrive(id : int, o : Order, pos : int)
signal customerServeSuccess()
signal gameOver()

@export var newCustomerTimer : Timer
@export var youreTooFastTimer : Timer
@export var possibleWeapons : Array[Weapon] = []
var customerInstance = preload("res://Scenes/Customer.tscn")
var currentCustomers : int
# If [i] is true, space is available
var customerSlots : Array[bool]
var possibleCustomers : Array[bool]

# Called when the node enters the scene tree for the first time.
func _ready():
	currentCustomers = 0
	customerSlots = [true, true, true, true]
	possibleCustomers = [true, true, true, true, true, true, true]

func start():
	newCustomerTimer.stop()
	youreTooFastTimer.stop()
	instantiateCustomer()

func stop():
	newCustomerTimer.stop()
	youreTooFastTimer.stop()

func instantiateCustomer():
	for i in range(0, 3):
		if customerSlots[i]:
			var j = randi_range(0, 6)
			while not possibleCustomers[j]:
				j = randi_range(0, 6)
			var tempObject = customerInstance.instantiate()
			$Customers.add_child(tempObject)
			tempObject.position = Vector2i(128 + (i * 256), 440)
			tempObject.initializeCustomer(j)
			tempObject.connect("timeOver", timeOver)
			for k in range(0, currentCustomers):
				tempObject.addGraceTime(randi_range(20, 30))
			tempObject.startOrder(possibleWeapons[randi()%possibleWeapons.size()])
			customerSlots[i] = false
			possibleCustomers[j] = false
			currentCustomers += 1
			customerArrive.emit(j, tempObject.baseOrder, i)
			break
	if currentCustomers < 4:
		if newCustomerTimer.is_stopped():
			newCustomerTimer.start(randi_range(15, 20))
			print("timer is activated: " + str(newCustomerTimer.time_left))
		else: print("timer is NOT stopped")

func customerServed(customerID : int):
	var temp = 0
	for n in $Customers.get_children():
		if customerID == n.customerID:
			$Customers.remove_child(n)
			n.queue_free()
			customerSlots[temp] = true
			possibleCustomers[customerID] = true
			currentCustomers -= 1
			if currentCustomers == 0:
				youreTooFastTimer.start(3)
			if newCustomerTimer.is_stopped():
				newCustomerTimer.start(randi_range(15, 20))
				print("timer is activated: " + str(newCustomerTimer.time_left))
			else: print("timer is NOT stopped")
			customerServeSuccess.emit()
		else: 
			temp += 1
			

func _on_temp_timer_timeout():
	instantiateCustomer()

func _on_new_customer_timer_timeout():
	instantiateCustomer()

func timeOver():
	print("counter timeOver emit")
	gameOver.emit()
