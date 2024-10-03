extends Node

var memory = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# You're free to *not* list every memory in here, when they're first
	# introduced, they'll just be "false"
	
	
	
	memory = {
		"knife": false,
		"suspicion": false,
		"paranoia": false,
		"clues": {
			"test": ["test", "test"],
			"test2": ["test2", "test2"]
		}
	}

func _to_string():
	return str(memory)
