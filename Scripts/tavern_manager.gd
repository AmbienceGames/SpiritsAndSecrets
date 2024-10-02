extends Node2D

@export
var tavern_screens: Array[Node2D] = []
var current_screen = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tavern_screens[current_screen].visible = true
	set_arrows()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		_cycle_left()
	elif Input.is_action_just_released("Right"):
		_cycle_right()
	

func _cycle_right() -> void:
	var next_screen = current_screen + 1
	if next_screen > len(tavern_screens) - 1:
		next_screen = 0
		
	tavern_screens[next_screen].visible = true
	tavern_screens[current_screen].visible = false
	current_screen = next_screen
	set_arrows()


func _cycle_left() -> void:
	var next_screen = current_screen - 1
	if next_screen < 0:
		next_screen = len(tavern_screens) - 1
		
	tavern_screens[next_screen].visible = true
	tavern_screens[current_screen].visible = false
	current_screen = next_screen
	set_arrows()

func set_arrows(): 
	var right_screen = current_screen + 1
	if right_screen > len(tavern_screens) - 1:
		right_screen = 0
	$HUD/RightText.text = tavern_screens[right_screen].name
	var left_screen = current_screen - 1
	if left_screen < 0:
		left_screen = len(tavern_screens) - 1
	$HUD/LeftText.text = tavern_screens[left_screen].name




func _on_right_arrow_button_down():
	$HUD/RightArrow.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	$HUD/RightText.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	


func _on_right_arrow_button_up():
	$HUD/RightArrow.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	$HUD/RightText.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _on_left_arrow_button_down():
	$HUD/LeftArrow.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
	$HUD/LeftText.vertical_alignment = VERTICAL_ALIGNMENT_TOP


func _on_left_arrow_button_up():
	$HUD/LeftArrow.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	$HUD/LeftText.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
