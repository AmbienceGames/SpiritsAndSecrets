extends Node2D

@export
var ingredient_path: NodePath
var ingredient
@export
var image: Texture
@export
var half_image: Texture
@export
var empty_image: Texture
# Called when the node enters the scene tree for the first time.
func _ready():
	ingredient = get_node(ingredient_path)
	$Sprite2D.texture = image


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ingredient.curr_count >= 0:
		if ingredient.curr_count == 0:
			$Sprite2D.texture = empty_image
		elif ingredient.curr_count <= ingredient.count / 2:
			$Sprite2D.texture = half_image
