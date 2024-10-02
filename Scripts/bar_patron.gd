extends Patron

signal sprite_clicked(assoc)

var order_taken = false
var orders = 0

var guard = false
var nothing_to_say = false
var exited = false


@onready
var conversations: Array[Node] = get_node("Conversations").get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if guard:
		return
	if Globals.patron_orders_info[self.name][1] == 0:
		Globals.patron_orders_info[self.name][1] = randi_range(1, 3)
	update_icons()
	if Globals.patron_orders_info[self.name][0]:
		Globals.get_patron_order(self.name)
		$Button.text = "Take Order: " + Globals.patron_orders_info[self.name][0]
	orders = Globals.patron_orders_info[self.name][1]
	guard = true
	if order_taken:
		$Button.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.current_order and Globals.patron_orders_info[self.name][0] not in ["Default", null]:
		$Button.hide()
	elif not Globals.current_order and not order_taken:
		$Button.show()
	if Globals.current_order == null and Globals.patron_orders_info[self.name][0] == null and not order_taken:
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
	else:
		nothing_to_say = false	
	return returned_conversations



func _on_button_pressed():
	if order_taken == false:
		Globals.ordering_patron = self
		orders -= 1
		Globals.patron_orders_info[self.name][1] = orders
		update_icons()
		Globals.patron_orders_info[self.name][2] = max(Globals.current_stars, 1)
		$Button.disabled = true
		for recipe in Globals.recipes:
			if recipe.recipe_name == Globals.patron_orders_info[self.name][0]:
				Globals.current_order = recipe
				break
		$Button.text = "Waiting for: \n" + Globals.patron_orders_info[self.name][0]
		Globals.patron_orders_info[self.name][0] = null
		Globals.person_waiting = false
		
		
func update_icons():
	if Globals.patron_orders_info[self.name][1] < 1:
		$Drink1.visible = false
	if Globals.patron_orders_info[self.name][1] < 2:
		$Drink2.visible = false
	if Globals.patron_orders_info[self.name][1] < 3:
		$Drink3.visible = false
