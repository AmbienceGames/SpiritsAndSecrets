extends Node2D

var curr_clues = []

@onready
var BartenderMemory = get_node("/root/BartenderMemory")

var clueScene = preload("res://Scenes/Mystery_Board/clue.tscn")

var mysteries = [
	["Mystery", "Find the correct test", "Mystery_Test", ["name2"]]
]

var solution_trees = {
	"Mystery_Test": [{"name2": {}}, "Test_Memory"]
}

var solved_memories = {
	"Test_Memory": ["N/A", "test2 is the corrent test", "Test_Memory"]
}

var curr_mysteries = []
var board

# Called when the node enters the scene tree for the first time.
func _ready():
	board = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Globals.clues_updated:
		for clue in BartenderMemory.memory["clues"]:
			if clue not in curr_clues:
				add_clue(BartenderMemory.memory["clues"][clue])
		Globals.clues_updated = true
		add_mysteries()
	for child in board.get_children():
		if child.name.begins_with("Mystery"):
			var curr_mystery = solution_trees[child.clue_name]
			var check = recursive_child_check(curr_mystery[0], child)
			if not child.child_clues:
				check = false

			if check and curr_mystery[1] in solved_memories.keys():
				print("created solution clue")
				add_clue(solved_memories[curr_mystery[1]])
				solved_memories.erase(curr_mystery[1])
					
func recursive_child_check(tree, mystery_clue):
	if mystery_clue.child_clues:
		for clue_child in mystery_clue.child_clues:
			if clue_child.clue_name not in tree.keys():
				return false
			if not recursive_child_check(tree[clue_child.clue_name], clue_child):
				return false
		return true
	else:
		return true
		
func add_clue(info):
	curr_clues.append(info[2])
	var new_clue = clueScene.instantiate()
	new_clue.clue_giver = info[0]
	new_clue.clue_description = info[1]
	new_clue.clue_name = info[2]
	var note_texture = "res://Assets/Art/Mystery Board/clue" + str(randi_range(1,5)) + ".png"
	new_clue.find_child("Sprite2D").texture = load(note_texture)
	new_clue.position = Vector2(randi_range(200,1700),randi_range(200,900))
	board.add_child(new_clue)
	
func add_mysteries():
	for mystery in mysteries:
		if mystery[2] not in curr_mysteries:
			var check = false
			for clue in curr_clues:
				if clue in mystery[3]:
					check = true
					break
			if check:
				var new_clue = clueScene.instantiate()
				new_clue.clue_giver = mystery[0]
				new_clue.clue_description = mystery[1]
				new_clue.clue_name = mystery[2]
				new_clue.parent_clue = "Root Mystery"
				new_clue.name = "Mystery"
				var note_texture = "res://Assets/Art/Mystery Board/clue" + str(randi_range(1,5)) + ".png"
				new_clue.find_child("Sprite2D").texture = load(note_texture)
				new_clue.position = Vector2(randi_range(200,1700),randi_range(200,900))
				board.add_child(new_clue)
				curr_mysteries.append(mystery[2])
