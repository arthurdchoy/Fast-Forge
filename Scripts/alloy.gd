extends Resource
class_name Alloy

enum ELEMENT {FIRE, LIGHT, ICE, PHYSICAL}

##Name of alloy
@export var alloyName : String
@export var alloyElement : ELEMENT

@export var alloyComponent1 : Metal
@export var alloyComponent1Amount : int

@export var alloyComponent2 : Metal
@export var alloyComponent2Amount : int

@export var alloyColor   : Color
@export var differentMoltenColor : bool #If checked, specified molten color will be different
@export var moltenColor  : Color

func calculate_mix_time():
	if alloyComponent1 and alloyComponent2 and alloyComponent1Amount and alloyComponent2Amount:
		var totalAmount = alloyComponent1Amount + alloyComponent2Amount
		var component1Ratio = alloyComponent1Amount/totalAmount
		var component2Ratio = alloyComponent2Amount/totalAmount
		return (alloyComponent1.metalInitMeltTimeInSeconds * component1Ratio) + (alloyComponent2.metalInitMeltTimeInSeconds * component2Ratio)
	else: return 0

func calculate_ingot_density():
	if alloyComponent1 and alloyComponent2 and alloyComponent1Amount and alloyComponent2Amount:
		var totalAmount = alloyComponent1Amount + alloyComponent2Amount
		var component1Ratio = alloyComponent1Amount/totalAmount
		var component2Ratio = alloyComponent2Amount/totalAmount
		return (alloyComponent1.metalIngotDensity * component1Ratio) + (alloyComponent2.metalIngotDensity * component2Ratio)
	else: return 0
