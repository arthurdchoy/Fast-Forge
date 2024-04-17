extends Base
class_name Alloy

##The first metal that makes this alloy.
@export var alloyComponent1 : Metal
##The amount of the first metal needed to mix the alloy.
@export var alloyComponent1Amount : int

##The second metal that makes this alloy.
@export var alloyComponent2 : Metal
##The amount of the second metal needed to mix the alloy.
@export var alloyComponent2Amount : int

@export var alloyBaseMixTime : int
##To be nice to the player, the mix time of an alloy will not increase if multiple ingots of the alloy is being made
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
