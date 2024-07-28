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


func _on_exit_game_pressed():
	get_tree().quit(0)

func _on_settings_pressed():
	print("me when i set the things")

func _on_back_pressed():
	visible = false
