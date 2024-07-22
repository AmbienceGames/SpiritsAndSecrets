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

func load_dialogue() -> void:
	var file = 
