extends Node

var memory = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# You're free to *not* list every memory in here, when they're first
	# introduced, they'll just be "false"
	memory = {
		"knife": false,
		"suspicion": false,
		"paranoia": false
	}

func _to_string():
	return str(memory)
