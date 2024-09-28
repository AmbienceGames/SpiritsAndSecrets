extends Node2D

class_name Clue

var clue_name = ""
var clue_description = ""

var is_pinned: bool = false
var is_connected: bool = false
var connected_to: Array = []  #Array of connected clues
var is_cancelable: bool = false
var clue_that_cancels = null  # Reference to the clue that cancels this one

# Called when the node enters the scene tree for the first time.
func _ready():
	$Name.text = clue_name
	$Description.text = clue_description

func pin_clue():
	is_pinned = true
	#need more code to actually place the clue rightfully lol
	
func connect_to_clue(clue: Clue):
	if clue != null and clue not in connected_to:
		$Pin.show()
		connected_to.append(clue)
		is_connected = true
		
func create_connection(clue_a: Clue, clue_b: Clue):
	if clue_a.is_connected or clue_b.is_connected: # Prevents the clues connecting if they're already connected, obviously
		return
	
	# Create a visual line to connect the clues, but there will probably be a better pixelated line so this is just temporary
	var line = Line2D.new()
	line.add_point(clue_a.find_child("Pin").global_position)
	line.add_point(clue_b.find_child("Pin").global_position)
	add_child(line)
	
	# Connect the clues to each other
	clue_a.connect_to_clue(clue_b)
	clue_b.connect_to_clue(clue_a)

#used to remove connections between two clues
func remove_connection(clue_a: Clue, clue_b: Clue):
	disconnect_clue(clue_a)
	disconnect_clue(clue_b)
	
	# Removes the lil' line thing connecting both clues
	for line in get_children():
		if line is Line2D:
			remove_child(line)

#just disconnects the clues by removing the clue they're connected to 
func disconnect_clue(clue: Clue): 
	if is_connected:
		emit_signal("disconnected_from_clue", connected_to)
		connected_to = []
		is_connected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
