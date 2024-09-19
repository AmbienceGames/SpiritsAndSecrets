extends Resource

var recipe: Recipe = null
var demands: Array[String] = []

func compare_to(g) -> float:
	
	var ingredients = g.ingredients
	var flavors = g.flavors
	var score = 1.0
	
	if recipe != null:
		print("Required:")
		for ingredient in recipe.ingredients:
			print(ingredient)
			if ingredient not in g.ingredients:
				score -= .3
		if recipe.glass_type != g.glass_name:
			score -= .2
		var extra_flavors = 1
		print("Extra:")
		for ingredient in g.ingredients:
			print(ingredient)
			if ingredient not in recipe.ingredients:
				extra_flavors -= 1
		score += extra_flavors * 0.1
	else:
		for d in demands:
			if d == "cold":
				if not g.ingredients.contains("Ice"):
					score -= .2
			else:
				if not d in g.flavors:
					score -= .3
		var extra_flavors = 1
		for f in g.flavors:
			if not f in demands:
				extra_flavors -= 1
		
		score += extra_flavors * 0.1
	print(score)
	return score

