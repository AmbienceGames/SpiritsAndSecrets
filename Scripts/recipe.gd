extends Resource

class_name Recipe

@export
var recipe_name: String

@export
var glass_type: String

@export
var ingredients: Array

@export 
var has_ice: bool

func generate_recipe_string() -> String:
	var temp_ingredients = ingredients
	var shaken = false
	var stirred = false
	if temp_ingredients[0] in ["Shaken", "Stirred"]:
		if temp_ingredients[0] == "Shaken":
			shaken = true
		elif temp_ingredients[0] == "Stirred":
			stirred = true
		temp_ingredients = temp_ingredients.slice(1)
	
	
	var str = recipe_name + ":\nAdd to " + glass_type + ":"
	
	for i in temp_ingredients:
		str += "\n- " + i
	
	if shaken: 
		str += "\nTransfer to Shaker and shake\nTransfer back to " + glass_type
	if stirred:
		str += "\nStir drink"

	str += "\nServe!"
	
	return str
