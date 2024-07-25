extends Node2D


var draggable = false
var offset: Vector2
var initialPos: Vector2
var array_of_bodies = []
var current
@onready
var label: Label = find_child("Label")

@export
var start_position: DropArea

@export 
var item_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = item_name
	current = start_position
	current.is_occupied = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			Globals.is_dragging = true
			array_of_bodies.clear()
			array_of_bodies.append(current)
			current.is_occupied =false
		if Input.is_action_pressed("click") and Globals.is_dragging:
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("click"):
			
			Globals.is_dragging = false
			var tween = get_tree().create_tween()
			if not array_of_bodies.is_empty():
				current = array_of_bodies.back()
				tween.tween_property(self,"position",current.position,0.1).set_ease(Tween.EASE_OUT)
				current.is_occupied = true
				array_of_bodies.clear()
			else:
				current = array_of_bodies.back()
				current.is_occupied = true
				tween.tween_property(self,"position",current.global_position,0.1).set_ease(Tween.EASE_OUT)


func _on_area_2d_mouse_entered():
	if not Globals.is_dragging:
		draggable = true
		label.visible = true
		scale = Vector2(1.05,1.05)


func _on_area_2d_mouse_exited():
	if not Globals.is_dragging:
		label.visible = false
		draggable = false
		scale = Vector2(1,1)


func _on_area_2d_body_entered(body):
	if body.is_in_group('dropable') and body.is_occupied == false:
		print("entered dropable "  + str(body.name))
		array_of_bodies.append(body)
		body.modulate = Color(Color.YELLOW,.3)


func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		print('exited dropable' + str(body.name))
		array_of_bodies.erase(body)
		if array_of_bodies.is_empty():
			array_of_bodies.append(current)
