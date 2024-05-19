extends Control

signal sendWeaponUp(w : Control)

enum WEAPON_TYPE {
	AXE,
	CUBE,
	DAGGER,
	FISTS,
	FRYING_PAN,
	GREATSWORD,
	HAMMER,
	RAPIER,
	SCYTHE,
	SPADE,
	SPEAR,
	STAFF,
	SWORD,
	NO_WEAPON
}

@export var possibleWeapons : Array[Weapon] = []
@export var weapon : Weapon
@export var sprite : TextureRect
@export var button : Button
@export var sMaterial : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.visible = false
	button.disabled = true

func setVisible(a : bool):
	sprite.visible = a

func disableButton(a : bool):
	button.disabled = a

func setWeapon(partArray : Array[Part]):
	var numBlades = 0
	var numHandles = 0
	var numCrossguards = 0
	var numPlates = 0
	var numBricks = 0
	for n in partArray:
		match n.type:
			n.PART_TYPE.BLADE:
				numBlades += 1
			n.PART_TYPE.HANDLE:
				numHandles += 1
			n.PART_TYPE.CROSSGUARD:
				numCrossguards += 1
			n.PART_TYPE.PLATE:
				numPlates += 1
			n.PART_TYPE.BRICK:
				numBricks += 1
	var temp = false
	for possibleW in possibleWeapons:
		if possibleW.checkCraft(numBlades, numHandles, numCrossguards, numPlates, numBricks):
			weapon = possibleW
			weapon.materials = partArray
			temp = true
	if temp == false:
		return false
	
	sprite.texture = weapon.texture
	
	var bladeArray : Array[Part] = []
	var handleArray : Array[Part] = []
	var crossguardArray : Array[Part] = []
	var plateArray : Array[Part] = []
	var brickArray : Array[Part] = []
	
	for n in partArray:
		match n.type:
			n.PART_TYPE.BLADE:
				bladeArray.push_back(n)
			n.PART_TYPE.HANDLE:
				handleArray.push_back(n)
			n.PART_TYPE.CROSSGUARD:
				crossguardArray.push_back(n)
			n.PART_TYPE.PLATE:
				plateArray.push_back(n)
			n.PART_TYPE.BRICK:
				brickArray.push_back(n)
	match weapon.type:
		WEAPON_TYPE.AXE:
			sMaterial.set("shader_parameter/new1", bladeArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", plateArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new3", handleArray[0].partMaterial.color)
		WEAPON_TYPE.CUBE:
			sMaterial.set("shader_parameter/new1", brickArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", brickArray[1].partMaterial.color)
			sMaterial.set("shader_parameter/new3", brickArray[2].partMaterial.color)
			sMaterial.set("shader_parameter/new4", brickArray[3].partMaterial.color)
		WEAPON_TYPE.DAGGER:
			sMaterial.set("shader_parameter/new1", bladeArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", handleArray[0].partMaterial.color)
		WEAPON_TYPE.FISTS:
			sMaterial.set("shader_parameter/new1", brickArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", brickArray[1].partMaterial.color)
			sMaterial.set("shader_parameter/new3", plateArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new4", plateArray[1].partMaterial.color)
		WEAPON_TYPE.FRYING_PAN:
			sMaterial.set("shader_parameter/new1", plateArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", plateArray[1].partMaterial.color)
			sMaterial.set("shader_parameter/new3", handleArray[0].partMaterial.color)
		WEAPON_TYPE.GREATSWORD:
			sMaterial.set("shader_parameter/new1", bladeArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", bladeArray[1].partMaterial.color)
			sMaterial.set("shader_parameter/new3", crossguardArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new4", handleArray[0].partMaterial.color)
		WEAPON_TYPE.HAMMER:
			sMaterial.set("shader_parameter/new1", brickArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", handleArray[0].partMaterial.color)
		WEAPON_TYPE.RAPIER:
			sMaterial.set("shader_parameter/new1", bladeArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", crossguardArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new3", crossguardArray[1].partMaterial.color)
			sMaterial.set("shader_parameter/new4", handleArray[0].partMaterial.color)
		WEAPON_TYPE.SCYTHE:
			sMaterial.set("shader_parameter/new1", bladeArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", bladeArray[1].partMaterial.color)
			sMaterial.set("shader_parameter/new3", plateArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new4", handleArray[0].partMaterial.color)
		WEAPON_TYPE.SPADE:
			sMaterial.set("shader_parameter/new1", plateArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", handleArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new3", handleArray[1].partMaterial.color)
		WEAPON_TYPE.SPEAR:
			sMaterial.set("shader_parameter/new1", bladeArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", handleArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new3", handleArray[1].partMaterial.color)
		WEAPON_TYPE.STAFF:
			sMaterial.set("shader_parameter/new1", handleArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", handleArray[1].partMaterial.color)
			sMaterial.set("shader_parameter/new3", handleArray[2].partMaterial.color)
		WEAPON_TYPE.SWORD:
			sMaterial.set("shader_parameter/new1", bladeArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new2", crossguardArray[0].partMaterial.color)
			sMaterial.set("shader_parameter/new3", handleArray[0].partMaterial.color)
	return true

func _on_select_button_pressed():
	sendWeaponUp.emit(self)
