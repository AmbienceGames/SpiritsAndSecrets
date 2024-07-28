extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pause_pressed():
	visible = true
	#make it so that time stops
	#disable other functions of the game so that players cannot just make drinks/talk while clock is stopped

func _on_exit_game_pressed():
	print("me when i exit the game")

func _on_settings_pressed():
	print("me when i set the things")

func _on_back_pressed():
	visible = false
