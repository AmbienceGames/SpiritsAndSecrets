extends Node

class_name ConversationItem

@onready 
var BartenderMemory = get_node("/root/BartenderMemory")
var ReferenceMemory = preload("res://Scripts/ref_memory.gd")

# The choice that initiates this conversation (from player)
@export
var player_choice: String
# The response then given by the patron
@export
var patron_response: String
# A list of memories that are required to have to access this conversation
# If the "inverse_memory" field is true, we check if we *don't* have this memory
@export
var memories_required: Array[ReferenceMemory]
# The memories unlocked by completing this conversation item
# If the "inverse_memory" field is true, we *lock* this memory
@export
var memories_unlocked: Array[ReferenceMemory]
# An arbitrary priority value that pushes conversations higher up the list
@export
var priority: int
# If this conversation has already been had or is no longer accessible
@export
var done: bool = false

# If this conversation is accessible via memory restrictions
func can_access():
	if done:
		return false
	if len(memories_required) == 0:
		return true
		
	var memory_required: String
	var inverse_memory: bool
	

	for memory in memories_required:
		memory_required = memory.memory_name
		inverse_memory = memory.inverse_memory
			
		if not BartenderMemory.memory.has(memory_required):
			BartenderMemory.memory[memory_required] = false
		
		if BartenderMemory.memory[memory_required] != not inverse_memory:
			return false

	return true

# Unlocks (or locks) a memory
func _grant_memory():
	if len(memories_unlocked) == 0:
		return false
	
	var memory_unlocked: String
	var inverse_unlock: bool
	for memory in memories_unlocked:
		memory_unlocked = memory.memory_name
		inverse_unlock = memory.inverse_memory
		
		BartenderMemory.memory[memory_unlocked] = not inverse_unlock

# Call this when the conversation is complete
func complete():
	done = true
	_grant_memory()

func _to_string():
	return player_choice + " -> " + patron_response
