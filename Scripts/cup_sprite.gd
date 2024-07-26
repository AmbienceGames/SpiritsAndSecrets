extends Node2D

#this is a sprite for any generic drink container
#the drink polygon2d should be shaped to match the container
#in the future nodes to hold positions for ice/garnish
#will be added

var drink: Polygon2D

@export
var texture: Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	find_child("Sprite2D").texture = texture
	drink = find_child("Drink")
	drink.set_color(Color(Color.AQUA, 0.0))
	pass # Replace with function body.

func update_color(combination: Combination):
	combination._update_color()
	drink.set_color(combination.color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
