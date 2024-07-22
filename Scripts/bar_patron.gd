extends Patron

signal sprite_clicked(assoc)


@onready
var conversations: Array[Node] = get_node("Conversations").get_children()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

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
