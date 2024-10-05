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
			"test": ["test", "test", "name1"],
			"test2": ["test2", "test2", "name2"],
			"test3": ["test3", "test3", "name3"],
			"test4": ["test4", "test4", "name4"]
		}
	}

func _to_string():
	return str(memory)
