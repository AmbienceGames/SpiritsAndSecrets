extends Patron

var ConversationItem = load("res://Scripts/conversation_item.gd")

signal sprite_clicked(assoc)

@export
var conversations: Array[ConversationItem] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
