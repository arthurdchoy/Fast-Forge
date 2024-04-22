extends Resource
class_name Order

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

@export var possibleMaterials : Array[Base]

var time : int = 0
var orderWeapon : Weapon
var type : ORDER_TYPE
var requirement

func determineRequirement(w : Weapon):
	orderWeapon = w
	print("order weapon: " + orderWeapon.baseWeaponName)
	print("weapon min weight: " + str(orderWeapon.getMinimumWeight()))
	print("weapon max weight: " + str(orderWeapon.getMaximumWeight()))
	type = ORDER_TYPE.values()[randi()%ORDER_TYPE.size()]
	match type:
		ORDER_TYPE.ELEMENT:
			requirement = ELEMENT.values()[randi()%ELEMENT.size()]
			print("element requirement generated")
			time = randi_range(75, 90)
		ORDER_TYPE.WEIGHT_UNDER:
			requirement = randf_range(orderWeapon.getMinimumWeight(), orderWeapon.getMaximumWeight())
			requirement = snappedf(requirement, 0.01)
			print("weight under requirement generated: " + str(requirement))
			time = randi_range(60, 80)
		ORDER_TYPE.WEIGHT_OVER:
			requirement = randf_range(orderWeapon.getMinimumWeight(), orderWeapon.getMaximumWeight())
			requirement = snappedf(requirement, 0.01)
			print("weight over requirement generated: " + str(requirement))
			time = randi_range(60, 90)
		ORDER_TYPE.COMPONENTS:
			print("component requirement generated")
			var maxParts = randi_range(1, orderWeapon.getMaximumParts())
			var temp : Array[Base] = []
			for n in range(0, maxParts):
				var tempMaterial = possibleMaterials[randi()%possibleMaterials.size()]
				if not temp.has(tempMaterial): temp.push_back(tempMaterial)
			requirement = temp
			for n in temp:
				if n is Metal:
					var tempTime = n.metalBaseMeltTimeInSeconds * 1.5
					time += randi_range(tempTime, tempTime+10)
				if n is Alloy:
					var tempTime = n.calculate_mix_time() * 2
					time += randi_range(tempTime, tempTime+20)
			print("weapoin max parts: " + str(orderWeapon.getMaximumParts()) + "\nrequirement max parts: " + str(maxParts))
			if orderWeapon.getMaximumParts() - maxParts != 0:
				print("adding extra part grace time")
				for n in range(1, orderWeapon.getMaximumParts() - maxParts):
					time += randi_range(30, 60)
	print("order time: " + str(time))

func checkRequirements(w : Weapon):
	if w.type != orderWeapon.type:
		return false
	match type:
		ORDER_TYPE.ELEMENT:
			print("element order: " + str(requirement))
			if w.getWeaponElement() != requirement:
				return false
		ORDER_TYPE.WEIGHT_UNDER:
			if not w.getWeaponWeight() < requirement:
				return false
		ORDER_TYPE.WEIGHT_OVER:
			if not w.getWeaponWeight() > requirement:
				return false
		ORDER_TYPE.COMPONENTS:
			var temp : bool = false
			for i in requirement:
				for j in w.materials:
					if i == j.partMaterial:
						temp = true
				if not temp: return false
				temp = false
	return true
