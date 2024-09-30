extends Node2D


var dragged_node: Node2D = null
var drink_scene = preload("res://Scenes/Ingredient_Screen/drink.tscn")
var occupied = false
var drink

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not drink and occupied:
		occupied = false
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and not occupied:
		# Make sure the event happens within a certain area (dragged_node, for example)
		if dragged_node:
			if dragged_node.is_bottle:
				create_drink(dragged_node)


func create_drink(dragged_node):
	drink = drink_scene.instantiate()
	var bottle_type = dragged_node.image.load_path
	drink.bottle_type = bottle_type
	drink.position = position
	self.get_parent().add_child(drink)
	occupied = true
	
func _on_area_2d_area_entered(area):
	var parent = area.get_parent()	
	if parent.name.begins_with("Ingredient") and parent.is_bottle:
		dragged_node = parent



func _on_area_2d_area_exited(area):
	var parent = area.get_parent()
	if dragged_node == parent:
		dragged_node = null
