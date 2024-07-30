extends Label

@export
var file = 'res://Recipes/Recipes.txt'
var pages: Array = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
var curr = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var text = FileAccess.open(file,FileAccess.READ)
	var rowIndex = 0
	var colIndex = 0
	while !text.eof_reached():
		if colIndex == 16:
			rowIndex += 1
			colIndex = 0
		pages[rowIndex] = pages[rowIndex] + text.get_line() + "\n"
		colIndex += 1
		
	
func _process(delta):	
	text = pages[curr]

func _on_left_arrow_pressed():
	curr = curr - 1

func _on_right_arrow_pressed():
	curr = curr + 1
