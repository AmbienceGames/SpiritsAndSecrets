extends Patron

signal sprite_clicked(assoc)


@onready
var conversations: Array[Node] = get_node("Conversations").get_children()
var order
var order_taken = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	order = Globals.get_patron_order(self.name)
	$Button.text += "\n" + order

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_conversations():
	var returned_conversations: Array[ConversationItem] = [null, null, null]
	conversations.sort_custom(func(a, b): return a.priority > b.priority)
	
	var pos: int = 0
	for conversation in conversations:
		if conversation.can_access():
			returned_conversations[pos] = conversation
			pos += 1 
		if pos >= len(returned_conversations):
			break;
	
	return returned_conversations



func _on_button_pressed():
	if order_taken == false:
		for recipe in Globals.recipes:
			if recipe.recipe_name == order:
				Globals.current_order = recipe
				break
		order_taken = true
		
		
