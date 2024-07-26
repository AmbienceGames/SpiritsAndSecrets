extends Node2D

var active = false

@export
var glass_to_spawn: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#when this is clicked, if possible, it creates a glass, and sets it to drag
	if Input.is_action_just_pressed("click") and not Globals.is_dragging and active:
		var glass = glass_to_spawn.instantiate()
		Globals.is_dragging = true
		glass.draggable = true
		glass.global_position = get_global_mouse_position()
		self.get_parent().add_child(glass)


func _on_area_2d_mouse_entered():
	if not Globals.is_dragging:
		active = true


func _on_area_2d_mouse_exited():
	active = false