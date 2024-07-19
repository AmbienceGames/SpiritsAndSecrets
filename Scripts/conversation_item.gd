extends Node

class_name ConversationItem

@onready 
var BartenderMemory = get_node("/root/BartenderMemory")

# The choice that initiates this conversation (from player)
@export
var player_choice: String
# The response then given by the patron
@export
var patron_response: String
# The memory required by the player to have to begin the interaction
# or "" if the conversation is already available
@export
var memory_required: String
# Classically (if inverse is False), we check if memory_required is True, 
# if inversed, we check if False
@export
var inverse_memory: bool = false
# The memory that is unlocked by completing this conversation item
# or "" if none is unlocked
@export
var memory_unlocked: String
# Again, rather than unlock a memory, this will lock a memory 
# (from memory_unlocked)
@export
var inverse_unlock: bool = false
# An arbitrary priority value that pushes conversations higher up the list
@export
var priority: int
# If this conversation has already been had or is no longer accessible
@export
var done: bool = false

func _init(chc, rsp, req, inv, unl, inv_unl, pri, comp):
	player_choice = chc
	patron_response = rsp
	memory_required = req
	inverse_memory = inv
	memory_unlocked = unl
	inverse_unlock = inv_unl
	priority = pri
	done = comp

# If this conversation is accessible via memory restrictions
func can_access():
	return (
		(memory_required == "" or
		BartenderMemory.memory.has(memory_required) == not inverse_memory)
		and not done
	)

# Unlocks (or locks) a memory
func _grant_memory():
	BartenderMemory.memory[memory_unlocked] = not inverse_unlock

# Call this when the conversation is complete
func complete():
	done = true
	_grant_memory()
