extends Node2D

const BarPatron = preload("res://Scripts/bar_patron.gd");


@onready
var bar_positions: Array[Node] = get_node("BarPositions").get_children()
var bar_seats: Array[Node2D] = [null, null, null, null]
var available_bar_seats: Array[int] = [0, 1, 2, 3]


@onready
var choices: Array[Node] = [get_node("HUD/Choice1"),get_node("HUD/Choice2"),get_node("HUD/Choice3")]
@export
var patron_response: Label = null

@export
var patron_factory: Node2D = null

@export
var exit_button: Button = null

var locked_color: Color = Color(0.3, 0.3, 0.3, 1) # Darkened color
var normal_color: Color = Color(1, 1, 1, 1) # Full brightness (white)

var target_buttons := ["Empty bar", "Fill bar", "Advance day"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if int(Globals.time) - Globals.time < .0167 and Globals.time - int(Globals.time) < .0167:
		if null in bar_seats and int(Globals.time) % 3 == 0:
			_spawn_patron()

					
	if not Globals.person_waiting:
		for patron in bar_seats:
			if patron and Globals.patron_orders_info[patron.name][0]:
				Globals.person_waiting = true
				break
	
	_check_for_buttons(self)

func _check_for_buttons(node: Node) -> void:
	for child in node.get_children():
		# If a button with the target text is found
		if child is Button and child.text in target_buttons:
			# Print information about the button
			print("Found target button:", child.text)
			print("Parent node:", child.get_parent().name)
			# Capture the call stack
			print("Call stack trace:\n", get_stack())
			# Optionally, stop the process loop once the button is found
			set_process(false)
			return
		# Continue checking recursively
		if child.get_child_count() > 0:
			_check_for_buttons(child)


func advance_day() -> void:
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
	
		
func _remove_patron(patron: BarPatron) -> void:
	if Globals.patron_orders_info[patron.name][1] == 0 or patron.nothing_to_say:
		patron.sprite_clicked.disconnect(_start_dialogue)
		if not patron.nothing_to_say:
			patron_factory.add_patron(patron)
		Globals.patron_orders_info[patron.name][0] = "Default"
		patron.queue_free()
		var index = bar_seats.find(patron)
		bar_seats[index] = null
		available_bar_seats.append(index)
		

func _spawn_patron() -> void:
	if len(available_bar_seats) == 0:
		return
	
	var patron = patron_factory.get_random_patron()
	
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

func _start_dialogue(patron: BarPatron) -> void:
	if patron.order_taken and not (patron.nothing_to_say or Globals.patron_orders_info[patron.name][2] == 0):
		patron.exited = false
		patron_response.visible = true
		patron_response.text = Globals.patron_curr_response[patron.name]
		_refresh_choices(patron)

func _end_dialogue(patron: BarPatron) -> void:
	print(patron)
	if is_instance_valid(patron):
		patron_response.visible = false
		
		for i in range(patron.get_conversations().size()):
			var button = choices[i]
			button.disabled = true
			button.visible = false
		
		exit_button.visible = false
		
		if exit_button.pressed.is_connected(_end_dialogue):
			exit_button.pressed.disconnect(_end_dialogue)
		
		patron.exited = true
		if patron.nothing_to_say or Globals.patron_orders_info[patron.name][2] == 0:
			patron.find_child("BarPatron").modulate = locked_color
		await get_tree().create_timer(randf_range(2.0,10.0)).timeout
		patron.order_taken = false
		Globals.get_patron_order(patron.name)
		patron.find_child("Button").text = "Take Order:\n" + Globals.patron_orders_info[patron.name][0] + "\n Orders remaining: " + str(Globals.patron_orders_info[patron.name][1])
		patron.find_child("Button").disabled = false
		patron.find_child("BarPatron").modulate = normal_color
		_remove_patron(patron)

func _choice_pressed(conversation: ConversationItem, patron: BarPatron):
	patron_response.text = conversation.patron_response
	Globals.patron_curr_response[patron.name] = conversation.patron_response
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
	if not (patron.nothing_to_say or Globals.patron_orders_info[patron.name][2] == 0):
		exit_button.visible = true
	var conversation: ConversationItem

		
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
