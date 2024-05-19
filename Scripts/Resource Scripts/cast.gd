extends Resource
class_name Cast

enum CAST_TYPE {
	BLADE,
	HANDLE,
	CROSSGUARD,
	PLATE,
	BRICK,
	DELETE
}

@export var castName : String
@export var coolingMultiplier : float
@export var castType : CAST_TYPE
@export var sprite : Texture2D
