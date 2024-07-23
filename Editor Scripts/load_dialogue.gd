@tool

extends EditorScript

func _run():
	var path = "res://Scenes/Characters"
	var script_path = "res://Dialogue/"
	var script_dir = DirAccess.open(path)
	var characters = script_dir.get_files()
	
	for filename in characters:
		print("Loading dialogue for " + filename)
		var character = load(path + "/" + filename) as PackedScene
		var root = character.instantiate()
		var temp = root.find_child("Conversations")
		if temp != null:
			root.remove_child(temp)

		var node = Node.new()
		node.name = "Conversations"
		root.add_child(node)
		load_dialogue(script_path + filename.replace("tscn","txt"), root)
		print("Dialogue loaded")

		root.find_child("Conversations",true,false).set_owner(root)
		for i in root.find_child("Conversations").get_children():
			i.set_owner(root)
		character.pack(root)
	
		
		print("Saving to " + path + "/" + filename)
		ResourceSaver.save(character,path + "/" + filename)


func load_dialogue(path: String, patron: Node) -> void:
	var file = FileAccess.open(path,FileAccess.READ)
	
	file.get_csv_line()
	var conv = patron.find_child("Conversations",true,false)
	var convs = []
	var conv_index = 0
	while not file.eof_reached():
		var line = file.get_csv_line()
		
		if (len(line) < 8 || line[0] == ""):
			continue
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
		if (int(line[7]) == 0):
			current.endDay = 100
		else:
			current.endDay = int(line[7])
		
		current.name = "conv" + str(conv_index)
		conv.add_child(current)
		current.set_owner(conv)
		convs.append(current)
		conv_index += 1
	
	

