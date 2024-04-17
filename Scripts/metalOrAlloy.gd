extends Resource
##The generic class that both [Metal]
##and [Alloy] are extended from.
class_name Base

enum ELEMENT {
	FIRE,		##Fire element 
	LIGHT, 		##Light/Holy element
	ICE, 		##Ice element
	PHYSICAL	##Physical/Neutral element, should not be attached to any alloy or metal directly
}

##Name of the metal or alloy.
@export var name : String
##Density of the metal or alloy.
@export var ingotDensity : float
##Element of the metal or alloy.
@export var element : ELEMENT

##Base cooling time of the metal or alloy, in seconds.
@export var coolingTime : int

##The color that will be put onto the metal or alloy sprite.
@export var color : Color
##If checked, moltenColor will be used to color the molten metal or alloy texture. Otherwise, alloyColor is used.
@export var differentMoltenColor : bool
##The color of the metal in molten form that will be overlaid on the molten metal or alloy texture. Only used if [member Base.differentMoltenColor] is checked.
@export var moltenColor : Color
