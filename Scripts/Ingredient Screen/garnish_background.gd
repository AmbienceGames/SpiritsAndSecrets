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

var normal_color: Color = Color(1, 1, 1, 1) # Full brightness (white)
var locked_color: Color = Color(0.3, 0.3, 0.3, 1) # Darkened color
var unlock_check = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ingredient = get_node(ingredient_path)
	$Sprite2D.texture = image
	if ingredient.unlocked:
		unlock_check = true
	else:
		$Sprite2D.modulate = locked_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ingredient.unlocked and not unlock_check:
		unlock_check = true
		$Sprite2D.modulate = normal_color
		
	if ingredient.curr_count >= 0:
		if ingredient.curr_count == 0:
			$Sprite2D.texture = empty_image
		elif ingredient.curr_count <= ingredient.count / 2:
			$Sprite2D.texture = half_image
		else:
			$Sprite2D.texture = image
