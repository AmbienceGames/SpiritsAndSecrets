extends Node2D


var draggable = false #can you drag it now?
var offset: Vector2 #how far is it from the mouse?
var initialPos: Vector2 #where should it fly back to
var drop_areas = [] #where can it be dropped?
var containers = [] #where can it be emptied?
var current #what was the last used drop_area?
@onready
var label: Label = find_child("Label")

@export
var start_position: DropArea

@export 
var item_name: String

@export
var liquid_inside: Liquid

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = item_name
	current = start_position
	current.is_occupied = true
	drop_areas.append(current)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if draggable: #can it be picked up? if no, skip
		
		if Input.is_action_just_pressed("click"): #pick it up
			offset = get_global_mouse_position() - global_position
			Globals.is_dragging = true
			if item_name == "Glass":
				Globals.dragged_container = self
			drop_areas.clear()
			drop_areas.append(current) #fallback if they don't put it anywhere
			current.is_occupied =false #set space to be open
			
		if Input.is_action_pressed("click") and Globals.is_dragging: 
			global_position = get_global_mouse_position() #snap to mouse
			
		elif Input.is_action_just_released("click"):
			
			Globals.is_dragging = false
			Globals.dragged_container = null
			var tween = get_tree().create_tween()
			
			if not drop_areas.is_empty(): #is there a place to go back to?
				current = drop_areas.back()
				tween.tween_property(self,"position",current.position,0.1).set_ease(Tween.EASE_OUT)
				current.is_occupied = true
				drop_areas.clear()
				drop_areas.append(current)
			
			if not containers.is_empty(): #is there a place to empty into?
					var cont = containers.back()
					cont.add(liquid_inside)
					containers.clear()


func _on_area_2d_mouse_entered():
	draggable = true
	if not Globals.is_dragging:
		label.visible = true
		scale = Vector2(1.05,1.05)


func _on_area_2d_mouse_exited():
	if not Globals.is_dragging:
		draggable = false
		label.visible = false
		scale = Vector2(1,1)


func _on_area_2d_body_entered(body):
	if body.is_in_group('dropable') and body.is_occupied == false:
		drop_areas.append(body)
		body.modulate = Color(Color.YELLOW,.3)

func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		drop_areas.erase(body)
		if drop_areas.is_empty():
			drop_areas.append(current)


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var c = area.get_parent()
	if c.is_in_group('container'):
		containers.append(c)


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var c = area.get_parent()
	if c.is_in_group('container'):
		containers.erase(c)
