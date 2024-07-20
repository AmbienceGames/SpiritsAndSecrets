extends Node2D

const BarPatron = preload("res://Scripts/bar_patron.gd");
const TablePatron = preload("res://Scripts/table_patron.gd");

@export
var bar_positions: Array[Node2D] = []
var bar_seats: Array[Node2D] = [null, null, null, null]
var available_bar_seats: Array[int] = [0, 1, 2, 3]

@export
var ordering_position: Node2D = null
var ordering_patron: Node2D = null

@export
var table_positions: Array[Node2D] = []
var table_seats: Array[Node2D] = [null, null, null, null]
var available_table_seats: Array[int] = [0, 1, 2, 3]

@export
var choices: Array[Button] = []
@export
var patron_response: Label = null

@export
var patron_factory: Node2D = null


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
		patron.sprite_clicked.connect(_start_dialogue)
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


func _start_dialogue(patron: BarPatron) -> void:
	patron_response.text = ""
	_refresh_choices(patron)

func _choice_pressed(conversation: ConversationItem, patron: BarPatron):
	patron_response.text = conversation.patron_response
	patron_response.visible = true
	conversation.complete()
	
	for choice in choices:
		if choice.pressed.is_connected(_choice_pressed):
			choice.pressed.disconnect(_choice_pressed)
	
	_refresh_choices(patron)

func _refresh_choices(patron: BarPatron):
	var conversations: Array[ConversationItem] = patron.get_conversations()
	var conversation: ConversationItem
	for index in conversations.size():
		conversation = conversations[index]
		var choice_button = choices[index]
		
		# Disable choice button if no conversation available
		if conversation == null:
			choice_button.text = ""
			choice_button.disabled = true
			choice_button.visible = false
			continue

		# Update choice buttons
		choice_button.text = conversation.player_choice
		choice_button.pressed.connect(
			_choice_pressed.bind(conversation, patron)
		)
		choice_button.disabled = false
		choice_button.visible = true
