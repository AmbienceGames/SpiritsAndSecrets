extends Node2D

const BarPatron = preload("res://Scripts/bar_patron.gd");
const TablePatron = preload("res://Scripts/table_patron.gd");


@onready
var bar_positions: Array[Node] = get_node("BarPositions").get_children()
var bar_seats: Array[Node2D] = [null, null, null, null]
var available_bar_seats: Array[int] = [0, 1, 2, 3]

@export
var ordering_position: Node2D = null
var ordering_patron: Node2D = null

@onready
var table_positions: Array[Node] = get_node("TablePositions").get_children()
var table_seats: Array[Node2D] = [null, null, null, null]
var available_table_seats: Array[int] = [0, 1, 2, 3]

@onready
var choices: Array[Node] = [get_node("HUD/Choice1"),get_node("HUD/Choice2"),get_node("HUD/Choice3")]
@export
var patron_response: Label = null

@export
var patron_factory: Node2D = null

@export
var exit_button: Button = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if int(Globals.time) - Globals.time < .0167 and Globals.time - int(Globals.time) < .0167:
		if null in bar_seats and int(Globals.time) % 3 == 0:
			_spawn_patron()
		if int(Globals.time) % 5 == 0:
			_empty_bar()
		if int(Globals.time) % 10 == 0:
			for patron in bar_seats:
				if patron and Globals.patron_orders_info[patron.name][2] == 0:
					Globals.get_patron_order(patron.name)
					patron.find_child("Button").text = Globals.patron_orders_info[patron.name][0] + "\n Orders remaining: " + str(Globals.patron_orders_info[patron.name][1])
					patron.find_child("Button").disabled = false
					
	if not Globals.person_waiting:
		for patron in bar_seats:
			if patron and Globals.patron_orders_info[patron.name][0]:
				Globals.person_waiting = true
				break


func advance_day() -> void:
	_empty_bar()
	Globals.day += 1
	patron_factory.bar_patrons = Globals.get_cast_for_day()
	_fill_bar()

func _fill_bar() -> void:
	for i in range(len(available_bar_seats)):
		var bpat = patron_factory.get_random_patron()
		var seat = available_bar_seats[i]
		bpat.global_position = bar_positions[seat].global_position
		bpat.sprite_clicked.connect(_start_dialogue)
		bar_seats[seat] = bpat
		add_child(bpat)
	available_bar_seats = []
	
		
func _empty_bar() -> void:
	for index in range(len(bar_seats)):
		var bpat = bar_seats[index]
		
		if bpat == null:
			continue
		
		if (Globals.patron_orders_info[bpat.name][1] == 0 and Globals.patron_orders_info[bpat.name][2] == 0) or bpat.nothing_to_say:
			bpat.sprite_clicked.disconnect(_start_dialogue)
			patron_factory.add_patron(bpat)
			bpat.queue_free()
			bar_seats[index] = null
			available_bar_seats.append(index)
		

func _spawn_patron() -> void:

	if len(available_bar_seats) == 0 and len(available_table_seats) == 0:
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
	if patron.order_taken and not patron.nothing_to_say:
		patron_response.text = ""
		_refresh_choices(patron)

func _end_dialogue(patron: BarPatron) -> void:
	patron_response.visible = false
	
	for i in range(patron.get_conversations().size()):
		var button = choices[i]
		button.disabled = true
		button.visible = false
	
	exit_button.visible = false
	if exit_button.pressed.is_connected(_end_dialogue):
		exit_button.pressed.disconnect(_end_dialogue)

func _choice_pressed(conversation: ConversationItem, patron: BarPatron):
	patron_response.text = conversation.patron_response
	patron_response.visible = true
	conversation.complete()
	
	
	for choice in choices:
		if choice.pressed.is_connected(_choice_pressed):
			choice.pressed.disconnect(_choice_pressed)
	
	Globals.patron_orders_info[patron.name][2] -= 1
	_refresh_choices(patron)

func _refresh_choices(patron: BarPatron):
	if not exit_button.pressed.is_connected(_end_dialogue):
		exit_button.pressed.connect(_end_dialogue.bind(patron))
	
	var conversations: Array[ConversationItem] = patron.get_conversations()
	if not patron.nothing_to_say:
		exit_button.visible = true
	var conversation: ConversationItem
	if Globals.patron_orders_info[patron.name][2] == 0:
		patron.order_taken = false
		Globals.patron_orders_info[patron.name][0] = "Default"
		
	for index in range(conversations.size()):
		conversation = conversations[index]
		var choice_button = choices[index]
		
		# Disable choice button if no conversation available
		if conversation == null or Globals.patron_orders_info[patron.name][2] == 0:
			choice_button.text = ""
			choice_button.disabled = true
			choice_button.visible = false
			continue


		# Update choice buttons
		choice_button.text = conversation.player_choice
		#disconnect choice from last character's dialogue
		if choice_button.pressed.is_connected(_choice_pressed):
			choice_button.pressed.disconnect(_choice_pressed)
		if not choice_button.pressed.is_connected(_choice_pressed):
			choice_button.pressed.connect(
				_choice_pressed.bind(conversation, patron)
			)
			choice_button.disabled = false
			choice_button.visible = true
