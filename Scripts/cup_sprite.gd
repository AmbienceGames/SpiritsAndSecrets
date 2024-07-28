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

@onready
var garnish_1: Node2D = find_child("Garnish1")

@onready
var garnish_2: Node2D = find_child("Garnish2")

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
	
	garnish_1.visible = false
	garnish_2.visible = false
	if not combination.garnishes.is_empty() or not combination.mixed_garnishes.is_empty():
		var occupied = 0
		for g in combination.garnishes:
			if occupied == 0:
				garnish_1.get_child(0).texture = g.texture
				occupied += 1
				garnish_1.visible = true
			elif occupied == 1:
				garnish_2.get_child(0).texture = g.texture
				occupied += 1
				garnish_2.visible = true
			else:
				return
		for g in combination.mixed_garnishes:
			if occupied == 0:
				garnish_1.get_child(0).texture = g.texture
				occupied += 1
				garnish_1.visible = true
			elif occupied == 1:
				garnish_2.get_child(0).texture = g.texture
				occupied += 1
				garnish_2.visible = true
			else:
				return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
