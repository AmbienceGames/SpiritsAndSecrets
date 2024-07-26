extends Resource
class_name Combination

var name = "Combination"

var mix_type: String = "none" #none, shaken, stirred
var liquids: Array[Liquid] = []
var flavors: Array[String] = []
var color: Color = Color(0,0,0,0)
var cost: int
var has_ice = false

func add(new):

	if new.name == "Liquid":
		_add_liquid(new)
	elif new.name == "Combination":
		_add_combination(new)
	elif new is Ice:
		print("ICED")
		has_ice = true
	_update_color()	

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

