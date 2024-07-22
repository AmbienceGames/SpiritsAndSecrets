extends Node2D

@export
var tavern_screens: Array[Node2D] = []
var current_screen = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tavern_screens[current_screen].visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _cycle_right() -> void:
	var next_screen = current_screen + 1
	if next_screen > len(tavern_screens) - 1:
		next_screen = 0
		
	tavern_screens[next_screen].visible = true
	tavern_screens[current_screen].visible = false
	current_screen = next_screen


func _cycle_left() -> void:
	var next_screen = current_screen - 1
	if next_screen < 0:
		next_screen = len(tavern_screens) - 1
		
	tavern_screens[next_screen].visible = true
	tavern_screens[current_screen].visible = false
	current_screen = next_screen

func load_dialogue(path: String, ) -> void:
	var file = FileAccess.open(path,FileAccess.READ)
	
	file.get_csv_line()
	
	var convs = []
	
	while not file.eof_reached():
		var line = file.get_csv_line()
		var current = ConversationItem.new()
		current.player_choice = line[0]
		current.patron_response = line[1]
		
		var temp
		
		for s in line[2].split(","):
			if s == "":
				break
			temp = ReferenceMemory.new()
			temp.memory_name = s
			current.memories_required.append(temp)
	
		for s in line[3].split(","):
			if s == "":
				break
			temp = ReferenceMemory.new()
			temp.memory_name = s
			current.memories_unlocked.append(temp)
		
		for s in line[4].split(","):
			if s == "":
				break
			temp = ReferenceMemory.new()
			temp.memory_name = s
			temp.inverse_memory = true
			current.memories_required.append(temp)
	
		for s in line[5].split(","):
			if s == "":
				break
			temp = ReferenceMemory.new()
			temp.memory_name = s
			temp.inverse_memory = true
			current.memories_unlocked.append(temp)
		
		current.startDay = int(line[6])
		current.endDay = int(line[7])
		
		convs.append(current)
		
	
