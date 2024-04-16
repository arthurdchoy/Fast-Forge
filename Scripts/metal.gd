extends Resource
class_name Metal

enum ELEMENT {FIRE, LIGHT, ICE, PHYSICAL}

##Name of metal
@export var metalName          : String
@export var metalIngotDensity  : float 		#For the sake of simplicity, metal density will just be it's real world g/cubic centimeter density
@export var metalElement       : ELEMENT

@export var metalInitMeltTimeInSeconds  : int #Initial melt time is relative to real world melting point

@export var metalColor	: Color #Metal color will be applied to a generic bar sprite and part
@export var differentMoltenColor : bool #If checked, molten color can be changed to be different from base metal color
@export var moltenColor : Color #Color of metal when it is molten

# If only one ingot is being melted, return the initial melt time
# For every additional ingot being melted, add 1/3 of the initial melt time to the total time to melt
func calculate_melt_time(ingots : int):
	if ingots == 1: return metalInitMeltTimeInSeconds
	elif ingots >  1: return metalInitMeltTimeInSeconds + (((ingots-1)*metalInitMeltTimeInSeconds)/3)
	return 0
