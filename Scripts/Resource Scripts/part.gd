extends Resource
class_name Part

enum PART_TYPE {
	BLADE,
	HANDLE,
	CROSSGUARD,
	PLATE,
	BRICK
}

## Export variables
## Name of the part
var partName : String

## Internal variables
## Material of the part. Because this is determined in runtime, it is not an export variable
var partMaterial : Base
var texture : Texture2D
var type : PART_TYPE

func calculateWeight():
	var density : float
	if partMaterial is Metal:
		density = partMaterial.ingotDensity
	elif partMaterial is Alloy:
		density = partMaterial.calculate_ingot_density()
	match type:
		PART_TYPE.BLADE:
			return density
		PART_TYPE.HANDLE:
			return density * 0.75
		PART_TYPE.CROSSGUARD:
			return density * 0.5
		PART_TYPE.PLATE:
			return density * 2
		PART_TYPE.BRICK:
			return density * 3
