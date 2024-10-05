extends Node2D

class_name Clue

var clue_giver = ""
var clue_description = ""
var clue_name = ""

var child_clues = []
var parent_clue = null

var lines = []

var is_pinning = false
var is_pinned = false
var pinning_line: Line2D = null
var is_hovered = false

var cursortexture = null

var is_dragging = false

@onready
var lineScene = preload("res://Scenes/removable_line.tscn")

func _ready():
	$Clue_Giver.text = clue_giver + " (" + clue_name + ")"
	$Description.text = clue_description
	var color_pin = str(randi_range(1, 10))
	var pin_texture = "res://Assets/Art/Mystery Board/TopDownPin" + color_pin + ".png"
	$Pin.texture = load(pin_texture)
	cursortexture = load("res://Assets/Art/Mystery Board/PinCursor" + color_pin + ".png")
	
func _process(delta):
	if Globals.pinning not in [self, null] and is_hovered:
		Input.set_custom_mouse_cursor(cursortexture)
		if Input.is_action_just_pressed("Pin") and not parent_clue and not Globals.pinning in child_clues:
			make_pinned()
			Globals.pinning.make_unpinning()
			$Clue_Parent.text = "Connected to: " + parent_clue.clue_name
	if is_pinning:
		pinning_line.set_point_position(1, get_global_mouse_position())
	if is_dragging:
		z_index = 1
		position = get_global_mouse_position()
		for line in lines:
			line[2].find_child("Line2D").set_point_position(line.find(clue_name), position+Vector2(0,-52))
	else:
		z_index = 0
		
func make_pinning():
	if not Globals.pinning:
		$Pin.visible = true
		pinning_line = Line2D.new()
		pinning_line.default_color = Color("#8b0000")
		pinning_line.width = 5
		pinning_line.add_point(position + Vector2(0,-52))
		pinning_line.add_point(get_global_mouse_position())
		get_parent().add_child(pinning_line)
		is_pinning = true
		Globals.pinning = self
		Input.set_custom_mouse_cursor(cursortexture)
	
func make_unpinning():
	if not child_clues and not parent_clue:
		$Pin.visible = false
	pinning_line.queue_free()
	pinning_line = null
	is_pinning = false
	Globals.pinning = null
	Input.set_custom_mouse_cursor(null)

func make_pinned():
	Globals.pinning.is_pinned = true
	is_pinned = true
	var new_line = lineScene.instantiate()
	new_line.parent_clue = Globals.pinning
	new_line.child_clue = self
	new_line.find_child("Line2D").add_point(position + Vector2(0,-52))
	new_line.find_child("Line2D").add_point(Globals.pinning.position + Vector2(0,-52))
	lines.append([clue_name, Globals.pinning.clue_name, new_line])
	Globals.pinning.lines.append([clue_name, Globals.pinning.clue_name, new_line])
	get_parent().add_child(new_line)
	Globals.pinning.child_clues.append(self)
	parent_clue = Globals.pinning
	$Pin.visible = true
	
func make_unpinned():
	pass
	
func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not Globals.top_clue:
					is_dragging = true
					Globals.top_clue = true
				else:
					is_dragging = false
			else:
				is_dragging = false
				Globals.top_clue = false
		elif event.button_index == MOUSE_BUTTON_RIGHT and Input.is_action_just_pressed("Pin") and event.pressed:
			if not is_pinning:
				make_pinning()
			elif is_pinning:
				make_unpinning()
				

func _on_area_2d_mouse_entered():
	is_hovered = true



func _on_area_2d_mouse_exited():
	is_hovered = false




















#
#var clue_name = ""
#var clue_description = ""
#
#var is_pinned: bool = false
#var is_connected: bool = false
#var connected_to: Array = []  #Array of connected clues
#var is_cancelable: bool = false
#var clue_that_cancels = null  # Reference to the clue that cancels this one
#var is_dragging = false
#var line = null
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#$Name.text = clue_name
	#$Description.text = clue_description
#
#func pin_clue():
	#is_pinned = true
	#Globals.pinning = self
	#line = Line2D.new()
	#line.add_point($Pin.position)
	#line.add_point(get_local_mouse_position())
	#add_child(line)
	#$Pin.show()
	#Input.set_custom_mouse_cursor(load("res://Assets/Art/Mystery Board/PinCursor.png"))
	##need more code to actually place the clue rightfully lol
#
#func unpin_clue():
	#if not connected_to:
		#$Pin.hide()
		#remove_child(line)
	#is_pinned = false
	#line = null
	#Globals.pinning = null
	#Input.set_custom_mouse_cursor(null)
		#
#
#func unpin_post_connection():
	#is_pinned = false
	#line = null
	#Globals.pinning = null
	#Input.set_custom_mouse_cursor(null)
	#
#func connect_to_clue(clue):
	#if clue != null and clue not in connected_to:
		#$Pin.show()
		#connected_to.append(clue)
		#is_connected = true
		#
#func create_connection(clue_a: Clue):
	#if clue_a.is_connected or is_connected: # Prevents the clues connecting if they're already connected, obviously
		#return
	#
	## Create a visual line to connect the clues, but there will probably be a better pixelated line so this is just temporary
	#var line = Line2D.new()
	#line.add_point(clue_a.find_child("Pin").position)
	#line.add_point(find_child("Pin").position)
	#add_child(line)
	#print("added line")
	#
	## Connect the clues to each other
	#clue_a.connect_to_clue(self)
	#connect_to_clue(clue_a)
#
#func remove_connections():
	#for connection in connected_to:
		#remove_connection(self, connection)
		#
##used to remove connections between two clues
#func remove_connection(clue_a: Clue, clue_b: Clue):
	#disconnect_clue(clue_a)
	#disconnect_clue(clue_b)
	#
	## Removes the lil' line thing connecting both clues
	#for line in get_children():
		#if line is Line2D:
			#remove_child(line)
#
##just disconnects the clues by removing the clue they're connected to 
#func disconnect_clue(clue: Clue): 
	#if is_connected:
		#emit_signal("disconnected_from_clue", connected_to)
		#connected_to = []
		#is_connected = false
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if is_dragging:
		#global_position = get_global_mouse_position()
	#if is_pinned:
		#line.set_point_position(1, get_local_mouse_position())
#
#func _on_area_2d_input_event(viewport, event, shape_idx):
	#
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed and not Globals.top_clue:
			#is_dragging = true
			#Globals.top_clue = true
		#else:
			#is_dragging = false
			#Globals.top_clue = false
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and Input.is_action_just_pressed("Pin"):
		#if is_pinned and Globals.pinning:
			#print("Stopped Pinning")
			#unpin_clue()
		#elif is_pinned:
			#print("Removed Pins")
			#remove_connections()
		#elif not is_pinned and Globals.pinning not in [self, null]:
			#print("Created Connection")
			#create_connection(Globals.pinning)
			#print("Stopped Pinning after connection")
			#Globals.pinning.unpin_post_connection()
		#else:
			#print("Started Pinning")
			#pin_clue()




