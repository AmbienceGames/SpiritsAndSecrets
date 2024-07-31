extends Node2D

class_name Ice

var draggable = false #can you drag it now?
var offset: Vector2 #how far is it from the mouse?
var containers

@export
var start_position: DropArea


# Called when the node enters the scene tree for the first time.
func _ready():
	containers = []
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if draggable: #can it be picked up? if no, skip
		
		if Input.is_action_just_pressed("click"): #pick it up
			offset = get_global_mouse_position() - global_position
			Globals.is_dragging = true
			Globals.dragged_container = null
			
		if Input.is_action_pressed("click") and Globals.is_dragging: 
			global_position = get_global_mouse_position() #snap to mouse
			
		elif Input.is_action_just_released("click"):
			
			Globals.is_dragging = false
			Globals.dragged_container = null
	
			if not containers.is_empty(): #is there a place to empty into?
				print("HERE")
				var cont = containers.back()
				cont.add(Ice.new())
				containers.clear()
				self.queue_free()
			else:
				self.queue_free()


func _on_area_2d_mouse_entered():
	draggable = true
	if not Globals.is_dragging:
		scale = Vector2(1.05,1.05)


func _on_area_2d_mouse_exited():
	if not Globals.is_dragging:
		draggable = false
		scale = Vector2(1,1)


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var c = area.get_parent()
	if c.is_in_group('container'):
		containers.append(c)


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var c = area.get_parent()
	if c.is_in_group('container'):
		containers.erase(c)
