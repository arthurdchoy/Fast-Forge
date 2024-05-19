extends Node2D

signal sendWeaponUp(w : Control)

enum ELEMENT {
	FIRE,		## Fire element 
	LIGHT, 		## Light/Holy element
	ICE, 		## Ice element
	PHYSICAL	## Physical/Neutral element, should not be attached to any alloy or metal directly
}

@export var weaponView : Control
@export var warningLabel : Label
@export var weaponDescLabels : Array[Label]
@export var clickSound : AudioStreamPlayer

var partSelectScene = preload("res://Scenes/PartSelect.tscn")
var weaponSelectScene = preload("res://Scenes/WeaponSelect.tscn")
var selectedParts : Array[Part] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	partialReset()

func partialReset():
	weaponView.setVisible(false)
	warningLabel.visible = false
	$WeaponDesc.visible = false

func receivePart(p : Part):
	var part = partSelectScene.instantiate()
	part.getPart(p)
	$PartsList/PartsContainer.add_child(part)
	part.connect("selected", _select_part)

func _select_part(part : Control):
	clickSound.play()
	if part.get_parent() == $PartsList/PartsContainer:
		if selectedParts.size() < 4:
			print("Moving to selected parts")
			part.reparent($SelectedParts)
			selectedParts.push_back(part.p)
		else: return
	elif part.get_parent() == $SelectedParts:
		print("Moving to parts box")
		part.reparent($PartsList/PartsContainer)
		selectedParts.erase(part.p)
	
	if selectedParts.size() > 0:
		if weaponView.setWeapon(selectedParts):
			weaponView.setVisible(true)
			weaponView.disableButton(false)
			warningLabel.visible = false
			weaponDescLabels[0].text = "Weapon Type: " + weaponView.weapon.baseWeaponName
			match weaponView.weapon.getWeaponElement():
				ELEMENT.FIRE:
					weaponDescLabels[1].text = "Weapon Element: Fire"
				ELEMENT.LIGHT:
					weaponDescLabels[1].text = "Weapon Element: Light"
				ELEMENT.ICE:
					weaponDescLabels[1].text = "Weapon Element: Ice"
				ELEMENT.PHYSICAL:
					weaponDescLabels[1].text = "Weapon Element: Physical"
			weaponDescLabels[2].text = "Weapon Weight: " + str(weaponView.weapon.getWeaponWeight()) + " ingots"
			weaponDescLabels[3].text = "Components:\n"
			for n in weaponView.weapon.materials:
				weaponDescLabels[3].text += "- " + n.partName + "\n"
			$WeaponDesc.visible = true
		else:
			weaponView.setVisible(false)
			weaponView.disableButton(true)
			warningLabel.visible = true
	else:
		weaponView.setVisible(false)
		weaponView.disableButton(true)
		warningLabel.visible = false

func _send_weapon_up(w : Control):
	clickSound.play()
	var temp = w.duplicate()
	temp.weapon.materials = w.weapon.materials.duplicate()
	temp.disconnect("sendWeaponUp", _send_weapon_up)
	temp.sprite = w.sprite
	sendWeaponUp.emit(temp)
	for n in $SelectedParts.get_children():
		$SelectedParts.remove_child(n)
		n.queue_free()
	selectedParts.clear()
	partialReset()
