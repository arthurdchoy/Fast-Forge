extends Resource
class_name Part

##Export variables
##Name of the part
@export var partName : String
##The amount of ingots required to cast this part.
@export var ingotCost : int
##The "cooling multiplier" of the part. A >0 float that will multiply the amount of time required to cool the specific part.
##This can be determined via multiple means of logic, but in general it will take into account [member Part.ingotCost] and the theoretical surface area of the part. 
@export var coolingMult : float

##Internal variables
##Material of the part. Because this is determined in runtime, it is not an export variable
var material : Base
var color : Color
