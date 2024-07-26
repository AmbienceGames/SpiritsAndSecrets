extends Node2D

var contents: Combination

#This is almost just a container but i added a few things to be able to mix
#Why didn't extend Container? Don't ask me. i don't know

var draggable = false
var offset: Vector2
var drop_areas = []
@onready
var label: Label = find_child("Label")

@export
var pos: DropArea

@export 
var item_name: String

var last_position: Vector2
var last_velocity: Vector2

var shakes 
var time 

var containers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pos.is_occupied = true
	contents = Combination.new()
	_update_label()
	last_position = position
	last_velocity = Vector2(0,0)
	shakes = 0
	time = 0


func mix() -> void:
	contents.mix_type = "shaken"
	_update_label()
	
func add(c) -> void:
	if c.name == "Combination" or c.name == "Liquid" or c is Ice:
		contents.add(c)
	print(contents.liquids)
	_update_label()

func _update_label():
	if contents.liquids.is_empty():
		label.text = "Mixer [Empty]"
	else:
		var st = "Mixer "
		st += "[" + contents.mix_type + "]"
		for l in contents.liquids:
			st += "\n- " + l.liquid_name
		label.text = st
	if contents.has_ice:
		label.text += "\n- Ice"

func empty() -> void:
	contents = Combination.new()
	_update_label()

func empty_into(other) -> void:
	other.add(contents)
	contents = Combination.new()
	_update_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			offset = get_global_mouse_position() - global_position
			Globals.is_dragging = true
			drop_areas.clear()
		if Input.is_action_pressed("click") and Globals.is_dragging:
			time += delta
			global_position = get_global_mouse_position()
			var velocity = (global_position - last_position) / delta
			var tmp1 = (last_velocity.x * last_velocity.y)
			var tmp2 = (velocity.x * velocity.y)
			if tmp1 > 0 and tmp2 < 0 or tmp2 > 0 and tmp1 < 0:
				shakes += 1
				if shakes > 7:
					mix()
			last_velocity = velocity
			last_position = global_position
			if time > 10:
				time = 0
				if shakes >0:
					shakes -= 1
		elif Input.is_action_just_released("click"):
			Globals.is_dragging = false
			var tween = get_tree().create_tween()
			if not drop_areas.is_empty():
				print(drop_areas)
				var cont = drop_areas.back()
				empty_into(cont)	
				drop_areas.empty()
			tween.tween_property(self,"position",pos.position,0.1).set_ease(Tween.EASE_OUT)
		
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


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var c = area.get_parent()
	if c.is_in_group('container'):
		containers.append(c)


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area == null:
		return
	var c = area.get_parent()
	if c.is_in_group('container'):
		containers.erase(c)

