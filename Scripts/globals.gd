extends Node


var day: int = 1

var cast: Array = [
	["trent","glanthor","constantine", "klaus","theo","lucius","lilianne","ethred"],
	["glanthor", "klaus","theo","lucius","lilianne","ethred"],
	["trent","glanthor","klaus","theo","lucius","lilianne","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
]

var is_dragging = false
var dragged_container = null

func get_cast_for_day() -> Array[PackedScene]:
	var names = cast[day-1]
	var path = "res://Scenes/Characters"
	var dir = DirAccess.open(path)
	var res: Array[PackedScene] = []
	for name in names:
		res.append(load(path + "/" + name + ".tscn"))
	return res

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


