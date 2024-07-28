extends Resource

var recipe: Recipe = null
var demands: Array[String] = []

func compare_to(g) -> float:
	if not g is Dropper or not g.has_contents:
		return 0.0
	
	var glass_contents: Combination = g.contents
	var score = 1.0
	
	if recipe != null:
		pass
	else:
		for d in demands:
			if d == "cold":
				if not glass_contents.has_ice:
					score -= .2
			else:
				if not d in glass_contents.flavors:
					score -= .3
		var extra_flavors = 1
		for f in glass_contents.flavors:
			if not f in demands:
				extra_flavors -= 1
		
		score += extra_flavors * 0.1
			
	return score

