extends Node2D

var parent_clue = null
var child_clue = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var start_point = $Line2D.points[0]
	var end_point = $Line2D.points[-1]

	# Calculate the difference in x and y
	var delta_xy = end_point - start_point

	# Calculate the length of the line
	var length = delta_xy.length()

	# Set the rectangle's extents (half the size)
	var new_shape = RectangleShape2D.new()
	new_shape.extents = Vector2(length / 2, 10 / 2)
	$Area2D/CollisionShape2D.shape = new_shape


	# Position the rectangle in the middle of the line
	$Area2D.position = (start_point + end_point) / 2

	# Rotate the CollisionShape2D to match the line's angle
	$Area2D.rotation = delta_xy.angle()



func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and Input.is_action_just_pressed("Pin") and event.pressed:
		parent_clue.is_pinned = false
		child_clue.is_pinned = false
		child_clue.parent_clue = null
		child_clue.find_child("Clue_Parent").text = ""
		parent_clue.child_clues.erase(child_clue)
		for line in child_clue.lines:
			if line[2] == self:
				child_clue.lines.erase(line)
				parent_clue.lines.erase(line)
		parent_clue.find_child("Pin").visible = false
		child_clue.find_child("Pin").visible = false
		queue_free()
		
