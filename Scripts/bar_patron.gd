extends Patron

signal sprite_clicked(assoc)

var order_taken = false
var guard = false
var nothing_to_say = false

var normal_color: Color = Color(1, 1, 1, 1) # Full brightness (white)
var locked_color: Color = Color(0.3, 0.3, 0.3, 1) # Darkened color

@onready
var conversations: Array[Node] = get_node("Conversations").get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if guard:
		return
	if Globals.patron_orders[self.name]:
		Globals.get_patron_order(self.name)
		$Button.text = "Take Order:\n" + Globals.patron_orders[self.name]
	guard = true
	if order_taken:
		$Button.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.current_order and Globals.patron_orders[self.name] not in ["Default", null]:
		$Button.hide()
	elif not Globals.current_order and not order_taken:
		$Button.show()
	if Globals.current_order == null and Globals.patron_orders[self.name] == null and not order_taken:
		order_taken = true
		$Button.hide()
	if order_taken:
		$Button.hide()
	

func get_conversations():
	var returned_conversations: Array[ConversationItem] = [null, null, null]
	conversations.sort_custom(func(a, b): return a.priority > b.priority)
	
	var check = true
	var pos: int = 0
	for conversation in conversations:
		if conversation.can_access():
			returned_conversations[pos] = conversation
			pos += 1 
			check = false
		if pos >= len(returned_conversations):
			break;
	if check:
		nothing_to_say = true
		$BarPatron.modulate = locked_color
	else:
		nothing_to_say = false
		$BarPatron.modulate = normal_color
	return returned_conversations



func _on_button_pressed():
	if order_taken == false:
		$Button.disabled = true
		for recipe in Globals.recipes:
			if recipe.recipe_name == Globals.patron_orders[self.name]:
				Globals.current_order = recipe
				break
		$Button.text = "Waiting for: \n" + Globals.patron_orders[self.name]
		Globals.patron_orders[self.name] = null
		Globals.person_waiting = false
		
		
