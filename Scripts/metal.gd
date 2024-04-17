extends Base
class_name Metal

@export var metalBaseMeltTimeInSeconds : int #Initial melt time is relative to real world melting point

# If only one ingot is being melted, return the initial melt time
# For every additional ingot being melted, add 1/3 of the initial melt time to the total time to melt
func calculate_melt_time(ingots : int):
	if ingots == 1: return metalBaseMeltTimeInSeconds
	elif ingots >  1: return metalBaseMeltTimeInSeconds + (((ingots-1)*metalBaseMeltTimeInSeconds)/3)
	return 0
