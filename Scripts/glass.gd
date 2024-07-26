extends Node2D

class_name Glass

var contents: Combination

var draggable = false
var offset: Vector2
var drop_areas = []
@onready
var label: Label = find_child("Label")

@export
var pos: DropArea

@export 
var item_name: String

@export
var containers = []

var current

var cup_sprite

var ice: Node2D
var bottom_ice: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if pos != null:
		pos.is_occupied = true
	contents = Combination.new()
	current = pos
	cup_sprite = find_child("CupSprite")
	_update_label()
	ice = find_child("Ice")
	bottom_ice = find_child("BottomIce")
	
func add(c) -> void:
	if c.name == "Combination" or c.name == "Liquid" or c is Ice:
		contents.add(c)
	_update_label()
	cup_sprite.update_color(contents)
	_update_ice_garnish()

func _update_ice_garnish():
	ice.visible = false
	bottom_ice.visible = false
	if contents.has_ice:
		print('iced')
		if contents.liquids.is_empty():
			bottom_ice.visible = true
		else:
			ice.visible = true
		
		

func _update_label():
	if contents.liquids.is_empty():
		label.text = "Glass [empty]"
	else:
		var st = "Glass "
		st += "[" + contents.mix_type + "]"
		for l in contents.liquids:
			st += "\n- " + l.liquid_name
		label.text = st
	if contents.has_ice:
		label.text += "\n- Ice"

func empty() -> void:
	contents = Combination.new()
	_update_label()
	cup_sprite.update_color(contents)
	_update_ice_garnish()

func empty_into(other) -> void:
	other.add(contents)
	contents = Combination.new()
	_update_label()
	cup_sprite.update_color(contents)
	_update_ice_garnish()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			Globals.is_dragging = true
			drop_areas.clear()
			drop_areas.append(current)
			if current != null: #just in case
				current.is_occupied =false 
			
		if Input.is_action_pressed("click") and Globals.is_dragging:
			global_position = get_global_mouse_position()
			
		elif Input.is_action_just_released("click"):
			Globals.is_dragging = false
			var tween = get_tree().create_tween()
			if not drop_areas.is_empty():
				current = drop_areas.back()
				if current == null: #just in case something goes horribly wrong
					self.queue_free()
					return
				tween.tween_property(self,"position",current.position,0.1).set_ease(Tween.EASE_OUT)
				current.is_occupied = true
				drop_areas.clear()
				drop_areas.append(current)
			else:
				#fallback if they don't put it anywhere
				self.queue_free()
			
			if not containers.is_empty():
				var cont = containers.back()
				empty_into(cont)
				containers.clear()
				_update_label()


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
	if area != null:
		var c = area.get_parent()
		if c.is_in_group('container'):
			containers.erase(c)
