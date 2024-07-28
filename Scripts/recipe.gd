extends Resource

class_name Recipe

@export
var glass_type: String

@export
var ingredients: Array[String]

@export
var mix_type: String

@export
var garnishes: Array[String]

@export 
var has_ice: bool

func generate_recipe_string() -> String:
	var str = mix_type + ":"
	
	for i in ingredients:
		str += "\n- " + i
	
	if has_ice:
		str += "\nAdd ice"
	
	str += "\nPour in " + glass_type
	
	if not garnishes.is_empty():
		str += "\nGarnish with:"
		for g in garnishes:
			str += "\n- " + g
	
	return str
