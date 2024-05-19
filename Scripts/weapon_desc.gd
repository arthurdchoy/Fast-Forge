extends VBoxContainer

enum ELEMENT {
	FIRE,		## Fire element 
	LIGHT, 		## Light/Holy element
	ICE, 		## Ice element
	PHYSICAL	## Physical/Neutral element, should not be attached to any alloy or metal directly
}

@export var labels : Array[Label] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hideLabels()

func showLabels():
	for l in labels:
		l.visible = true

func hideLabels():
	for l in labels:
		l.visible = false

func setLabels(w : Weapon):
	print("setting labels, weapon weight: " + str(w.getWeaponWeight()))
	setWeaponType(w.baseWeaponName)
	setWeaponElement(w.getWeaponElement())
	setWeaponWeight(w.getWeaponWeight())
	setWeaponComponents(w.materials)

# Helper functions
func setWeaponType(s : String):
	labels[0].text = "Weapon Type: " + s

func setWeaponElement(e : ELEMENT):
	var t : String = "Element: "
	match e:
		ELEMENT.FIRE:
			t += "Fire"
		ELEMENT.LIGHT:
			t += "Light"
		ELEMENT.ICE:
			t += "Ice"
		ELEMENT.PHYSICAL:
			t += "Physical"
	labels[1].text = t

func setWeaponWeight(i : float):
	labels[2].text = "Weight: " + str(i) + " ingots"

func setWeaponComponents(parts : Array[Part]):
	labels[3].text = "Components:"
	for n in parts:
		labels[3].text += "\n- " + n.partName
