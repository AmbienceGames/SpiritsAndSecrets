extends Node2D


#applicable to ALL droppers
var draggable = false #can you drag it now?
var offset: Vector2 #how far is it from the mouse?
var initialPos: Vector2 #where should it fly back to
var drop_areas = [] #where can it be dropped?
var containers = [] #where can it be emptied?
var current #what was the last used drop_area?

#specific to certian droppers

@export
var start_position: DropArea

@export 
var item_name: String

@export
var position_changeable: bool

@export
var can_be_emptied: bool

@export
var is_container: bool

@export
var has_label: bool
var label

@export 
var has_contents: bool
@export
var contents: Combination

@export
var has_just_one_liquid: bool
@export
var liquid_inside: Liquid

@export
var can_shake: bool
var time = 0
var shakes = 0
var last_velocity: Vector2 = Vector2(0,0)
var last_position: Vector2 = Vector2(0,0)

@export
var uses_cup_sprite: bool

@export 
var sprite_scene: PackedScene
var sprite

@export
var destroy_on_placement: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if has_label:
		label = find_child("Label")
		label.text = item_name
	
	if has_contents:
		if contents == null:
			contents = Combination.new()
			
	current = start_position
	
	if can_shake:
		last_position = current.global_position
	
	sprite = sprite_scene.instantiate()
	sprite.visible = true
	add_child(sprite)
	
	if current != null:
		current.is_occupied = true
		drop_areas.append(current)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if draggable: #can it be picked up? if no, skip
		
		if Input.is_action_just_pressed("click"): #pick it up
			offset = get_global_mouse_position() - global_position
			Globals.is_dragging = true
			drop_areas.clear()
			drop_areas.append(current) #fallback if they don't put it anywhere
			current.is_occupied =false #set space to be open
			
		if Input.is_action_pressed("click") and Globals.is_dragging: 
			global_position = get_global_mouse_position()
			if can_shake:
				time += delta
				var velocity = (global_position - last_position) / delta
				var tmp1 = (last_velocity.x * last_velocity.y)
				var tmp2 = (velocity.x * velocity.y)
				if tmp1 > 0 and tmp2 < 0 or tmp2 > 0 and tmp1 < 0:
					shakes += 1
					if shakes > 7:
						contents.mix_type = "Mixed"
						_update_label()
				last_velocity = velocity
				last_position = global_position
				if time > 10:
					time = 0
					if shakes >0:
						shakes -= 1
			
		elif Input.is_action_just_released("click"):
			
			Globals.is_dragging = false
			var tween = get_tree().create_tween()
			
			if position_changeable and not drop_areas.is_empty(): #is there a place to go back to?
				current = drop_areas.back()
				if current == null:
					self.queue_free()
				else:
					tween.tween_property(self,"position",current.position,0.1).set_ease(Tween.EASE_OUT)
					current.is_occupied = true
					drop_areas.clear()
					drop_areas.append(current)
			else:
				if current == null:
					self.queue_free()
				else:
					current.is_occupied = true
					tween.tween_property(self,"position",current.position,0.1).set_ease(Tween.EASE_OUT)
			
			if not containers.is_empty(): #is there a place to empty into?
				var container = containers.back()
				if has_contents:
					if can_be_emptied:
						empty_into(container)
					else:
						container.add(contents)
				elif has_just_one_liquid:
					container.add(liquid_inside)
				
				containers.clear()
			
			if destroy_on_placement:
				self.queue_free()

func add(c):
	if is_container:
		contents.add(c)
	_update_label()
	_update_sprite()

func empty():
	if is_container:
		contents = Combination.new()
	_update_label()
	_update_sprite()

func empty_into(other) -> void:
	other.add(contents)
	contents = Combination.new()
	_update_label()
	_update_sprite()

func _update_sprite():
	if uses_cup_sprite:
		sprite.update_sprite(contents)

func _update_label():
	if not has_label:
		return
	var str = item_name
	if is_container:
		str += " [" + contents.mix_type + "]"
		str += contents.get_content_list()
	label.text = str

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
	if draggable:
		var c = area.get_parent()
		if c.is_in_group('container'):
			containers.append(c)


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if draggable:
		if area == null:
			return
		var c = area.get_parent()
		if c.is_in_group('container'):
			containers.erase(c)

