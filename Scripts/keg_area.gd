extends Node2D

class_name KegArea

@export
var whats_inside: Combination

var time_to_fill = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered():
	if Globals.is_dragging:
		$TimeToFill.start(time_to_fill)

func _on_time_to_fill_timeout() -> void:
	if Globals.is_dragging and Globals.dragged_container != null:
		print("The keg strikes again")
		Globals.dragged_container.add(whats_inside)

