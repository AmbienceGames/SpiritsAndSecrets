extends Node2D

var toggle = false

var pages = []
var curr_page = [0,1]


# Called when the node enters the scene tree for the first time.
func _ready():
	for recipe in Globals.recipes:
		pages.append(recipe.generate_recipe_string())
	$BookText.text = pages[curr_page[0]]
	$BookText2.text = pages[curr_page[1]]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if toggle:
		$BookBackground.visible = false
		$BookText.visible = false
		$BookText2.visible = false
		$Left.visible = false
		$Right.visible = false
		toggle = false
	else:
		$BookBackground.visible = true
		$BookText.visible = true
		$BookText2.visible = true
		$Left.visible = true
		$Right.visible = true
		toggle = true


func _on_left_pressed():
	curr_page[0] -= 1
	if curr_page[0] < 0:
		curr_page[0] = pages.size() - 1
	curr_page[1] -= 1
	if curr_page[1] < 0:
		curr_page[1] = pages.size() - 1
	$BookText.text = pages[curr_page[0]]
	$BookText2.text = pages[curr_page[1]]
	
func _on_right_pressed():
	curr_page[0] += 1
	if curr_page[0] > pages.size() - 1:
		curr_page[0] = 0
	curr_page[1] += 1
	if curr_page[1] > pages.size() - 1:
		curr_page[1] = 0	
	$BookText.text = pages[curr_page[0]]
	$BookText2.text = pages[curr_page[1]]
