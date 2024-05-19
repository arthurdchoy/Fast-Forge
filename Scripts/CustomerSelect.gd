extends TextureRect

signal selected(id : int, o : Order)

var customerID : int
var order : Order

func _on_button_pressed():
	selected.emit(customerID, order)
