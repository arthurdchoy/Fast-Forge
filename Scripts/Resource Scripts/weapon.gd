extends Resource
class_name Weapon

enum ELEMENT {
	FIRE,		## Fire element 
	LIGHT, 		## Light/Holy element
	ICE, 		## Ice element
	PHYSICAL	## Physical/Neutral element, should not be attached to any alloy or metal directly
}
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

@export var baseWeaponName : String
@export var type : WEAPON_TYPE
## Number of blades this weapon needs to be assembled
@export var numBlades : int
## Number of handles this weapon needs to be assembled
@export var numHandles : int
## Number of crossguards this weapon needs to be assembled
@export var numCrossguards : int
## Number of plates this weapon needs to be assembled
@export var numPlates : int
## Number of bricks this weapon needs to be assembled
@export var numBricks : int

@export var texture : Texture2D

var materials : Array[Part] = []
func getMinimumWeight():
	return (float(numBlades) * 5.0) + (float(numHandles) * .75 * 5.0) + (float(numCrossguards) * .5 * 5.0) \
			+ (float(numPlates) * 2.0 * 5.0) + (float(numBricks) * 3.0 * 5.0)
			
func getMaximumWeight():
	return (float(numBlades) * 21.0) + (float(numHandles) * .75 * 21.0) + (float(numCrossguards) * .5 * 21.0) \
			+ (float(numPlates) * 2.0 * 21.0) + (float(numBricks) * 3.0 * 21.0)

func getMaximumParts():
	return numBlades + numHandles + numCrossguards + numPlates + numBricks

func checkCraft(blades : int, handles : int, crossguards : int, plates : int, bricks : int):
	if blades == numBlades \
	and handles == numHandles \
	and crossguards == numCrossguards \
	and plates == numPlates \
	and bricks == numBricks:
		return true
	else: return false

func verifyMaterials(m : Base, num : int):
	var numMatch : int = 0
	for n in materials:
		if n == m:
			numMatch += 1
	if numMatch == num: return true
	else: return false

func getWeaponWeight():
	var weight : float = 0
	for n in materials:
		weight += n.calculateWeight()
	return weight

func getWeaponElement():
	var numFire : int = 0
	var numLight : int = 0
	var numIce : int = 0
	for n in materials:
		match n.partMaterial.element:
			ELEMENT.FIRE:
				numFire += 1
			ELEMENT.LIGHT:
				numLight += 1
			ELEMENT.ICE:
				numIce += 1
	if numFire > numLight and numFire > numIce:
		return ELEMENT.FIRE
	elif numLight > numFire and numLight > numIce:
		return ELEMENT.LIGHT
	elif numIce > numFire and numIce > numLight:
		return ELEMENT.ICE
	else: return ELEMENT.PHYSICAL
