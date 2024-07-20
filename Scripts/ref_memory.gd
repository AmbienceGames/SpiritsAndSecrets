extends Resource

class_name ReferenceMemory

# The name of the memory
@export
var memory_name: String
# Whether to perform a *reverse* check on this memory 
# (check if we DON'T have it)
@export
var inverse_memory: bool = false

func _to_string() -> String:
	return memory_name + " " + str(inverse_memory)
