extends Node2D

#this is a sprite for any generic drink container
#the drink polygon2d should be shaped to match the container
#in the future nodes to hold positions for ice/garnish
#will be added

var drink: Polygon2D


@onready
var top_ice: Node2D = find_child("Ice")

@onready
var bottom_ice: Node2D = find_child("BottomIce")

# Called when the node enters the scene tree for the first time.
func _ready():
	drink = find_child("Drink")
	drink.set_color(Color(Color.AQUA, 0.0))

func update_color(combination: Combination):
	combination._update_color()
	drink.set_color(combination.color)

func update_sprite(combination: Combination):
	update_color(combination)
	top_ice.visible = false
	bottom_ice.visible = false
	if combination.has_ice:
		if combination.liquids.is_empty():
			bottom_ice.visible = true
		else:
			top_ice.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
