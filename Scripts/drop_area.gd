extends StaticBody2D

class_name DropArea

var is_occupied = false

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = Color(Color.GREEN,.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.is_dragging:
		visible = true
	else:
		visible = false
	
	if is_occupied:
		modulate = Color(Color.RED, 0.3)
	else:
		modulate = Color(Color.GREEN, 0.3)
