extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Menu"):
		if not visible:
			_on_pause_pressed()
		else:
			_on_back_pressed()

func _on_pause_pressed():
	visible = true
	Globals.paused = true
	#make it so that time stops


func _on_exit_game_pressed():
	get_tree().quit(0)

func _on_settings_pressed():
	pass

func _on_back_pressed():
	visible = false
	Globals.paused = false
