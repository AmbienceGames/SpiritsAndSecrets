extends Resource
class_name Combination

var name = "Combination"

var mix_type: String = "none" #none, shaken, stirred
var liquids: Array[Liquid] = []
var garnishes: Array[Garnish] = []
var mixed_garnishes: Array[Garnish] = []
var flavors: Array[String] = []
var color: Color = Color(0,0,0,0)
var cost: int
var has_ice = false

func add(new):
	if new is Liquid:
		_add_liquid(new)
	elif new is Combination:
		_add_combination(new)
	elif new is Ice:
		has_ice = true
	elif new is Garnish:
		_add_garnish(new)
	_update_color()	

func _add_garnish(g: Garnish):
	garnishes.append(g)
	print(garnishes)
	for f in g.flavors:
		if not f in flavors:
			flavors.append(g)
	cost += g.cost
	

func _add_liquid(l: Liquid):
	liquids.append(l)
	for f in l.flavors:
		if not f in flavors:
			flavors.append(f)
	cost += l.cost
	mix_type = "Unmixed"
	
func _add_combination(c: Combination):
	if liquids != []:
		mix_type = "Unmixed"
	else:
		mix_type = c.mix_type
	for l in c.liquids:
		liquids.append(l)
	for f in c.flavors:
		if not f in flavors:
			flavors.append(f)
	for g in c.garnishes:
		garnishes.append(g)
	for g in c.mixed_garnishes:
		mixed_garnishes.append(g)
	if c.has_ice:
		self.has_ice = true
	
	cost += c.cost

func _update_color():
	if (len(liquids)) == 0:
		color = Color(0,0,0,0)
		return
	var r = 0
	var g = 0
	var b = 0
	var a = 0
	var i = 0
	for l in liquids:
		var c = l.color
		r += c.r * c.a
		g += c.g * c.a
		b += c.b * c.a
		a += c.a * c.a
		i += c.a
	r /= i
	b /= i
	g /= i
	a /= i
	color = Color(r,g,b,a)

func get_content_list() -> String:
	var st = ""
	for l in liquids:
		st += "\n- " + l.liquid_name
	for g in mixed_garnishes:
		st += "\n- " + g.garnish_name
	if has_ice:
		st += "\n- Ice"
	if (garnishes.is_empty()):
		return st
	st += "\nGarnished with:"
	for g in garnishes:
		st += "\n- " + g.garnish_name
	return st

func mix(mixtype: String):
	mix_type = mixtype
	for g in garnishes:
		mixed_garnishes.append(g)
	garnishes.clear()
