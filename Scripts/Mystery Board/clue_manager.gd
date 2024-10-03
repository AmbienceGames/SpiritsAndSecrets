extends Node2D

var curr_clues = []

@onready
var BartenderMemory = get_node("/root/BartenderMemory")

var clueScene = preload("res://Scenes/Mystery_Board/clue.tscn")

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
		
	
func add_clue(info):
	curr_clues.append(info[0])
	var new_clue = clueScene.instantiate()
	new_clue.clue_giver = info[0]
	new_clue.clue_description = info[1]
	var note_texture = "res://Assets/Art/Mystery Board/clue" + str(randi_range(1,5)) + ".png"
	new_clue.find_child("Sprite2D").texture = load(note_texture)
	board.add_child(new_clue)
	
	
