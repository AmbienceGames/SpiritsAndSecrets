extends Node2D

const BarPatron = preload("res://Scripts/bar_patron.gd")
const TablePatron = preload("res://Scripts/table_patron.gd")

@export
var bar_positions: Array[Node2D] = []
@export
var ordering_position: Node2D = null
@export
var table_positions: Array[Node2D] = []

@export
var patron_factory: Node2D = null

var bar_seats: Array[Node2D] = [null, null, null, null]
var available_bar_seats: Array[int] = [0, 1, 2, 3]
var ordering_patron: Node2D = null
var table_seats: Array[Node2D] = [null, null, null, null]
var available_table_seats: Array[int] = [0, 1, 2, 3]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _spawn_patron() -> void:

	if len(available_bar_seats) == 0 and len(available_table_seats) == 0:
		print("Reached patron limit")
		return
	
	var patron = patron_factory.get_random_patron()
	
	while len(available_bar_seats) == 0 and patron is BarPatron:
		patron = patron_factory.get_random_patron()
	while len(available_table_seats) == 0 and patron is TablePatron:
		patron = patron_factory.get_random_patron()
	
	if patron is BarPatron:
		# Get a seat
		var index = randi() % available_bar_seats.size()
		var seat = available_bar_seats[index]
		available_bar_seats.remove_at(index)
		
		# Place the patron in it
		patron.global_position = bar_positions[seat].global_position
		bar_seats[seat] = patron
		add_child(patron)
	
	elif patron is TablePatron:
		# Get a seat
		var index = randi() % available_table_seats.size()
		var seat = available_table_seats[index]
		available_table_seats.remove_at(index)
		
		# Place the patron in it
		patron.global_position = table_positions[seat].global_position
		table_seats[seat] = patron
		add_child(patron)
