extends Node2D

var is_dragging = false
var mixer_transfer = false

var bottle_type: String = ""
var glass_name = ""
var place
var hovered_ingredient
var ingredients = []
var in_garbage
var timer_active = false
var can_transfer = true  # To manage cooldown between transfers
var cooldown_duration = .25

signal send_mixer(ingredient_list)

func _ready():
	var temp_name
	if bottle_type.ends_with(".ctex"):
		temp_name = bottle_type.substr(0, bottle_type.length() - 5)
	var start_idx = temp_name.rfind("/") + 1
	var end_idx = temp_name.rfind(".")
	var split_glass = temp_name.substr(start_idx, end_idx - start_idx).split("-")
	var capitalized_words = []
	for word in split_glass:
		capitalized_words.append(word.capitalize())
	glass_name = " ".join(capitalized_words)
	$Bottle.texture = load(bottle_type)
	print("drink made, type: " + glass_name)
	place = position
	$Label.text += glass_name + "\n"
	$Timer.wait_time = cooldown_duration
	$Timer.one_shot = true
	$Timer.connect("timeout", Callable(self, "_on_cooldown_finished"))
	
func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position()
		


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("moving drink")
		if event.pressed:
			is_dragging = true
		else:
			if in_garbage:
				queue_free()
			if hovered_ingredient:
				ingredients.append(hovered_ingredient)
				update_insides()
			if mixer_transfer and ingredients and can_transfer:  # Only transfer if cooldown allows
				can_transfer = false  # Disable transfer until cooldown ends
				$Timer.start()  # Start cooldown timer
				print("transfered items from drink to shaker, timer started")
				emit_signal("send_mixer", ingredients)  # Transfer ingredients to the mixer
				ingredients = []
				clear_insides()

			is_dragging = false
			position = place

func _on_cooldown_finished():
	print("timer finished")
	can_transfer = true  # Reset cooldown after the timer finishes


func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if area.name == "TrashArea":
		print("deleting")
		in_garbage = true
	elif parent.name.begins_with("Ingredient") and not parent.is_bottle:
		hovered_ingredient = parent.name.substr("Ingredients".length())
	elif parent.name == "Mixer":
		mixer_transfer = true
		if not area.get_parent().is_connected("send_mixer", Callable(self, "on_receive_list")) and not ingredients:
			area.get_parent().connect("send_mixer", Callable(self, "on_receive_list"))


func _on_area_2d_area_exited(area):
	var parent = area.get_parent()
	if area.name == "TrashArea":
		in_garbage = false
	elif parent.name.begins_with("Ingredient") and not parent.is_bottle:
		if hovered_ingredient == parent.name.substr("Ingredients".length()):
			hovered_ingredient = ""
	elif parent.name == "Mixer":
		mixer_transfer = false
		if area.get_parent().is_connected("send_mixer", Callable(self, "on_receive_list")) and not ingredients:
			area.get_parent().disconnect("send_mixer", Callable(self, "on_receive_list"))

func on_receive_list(list_data):
	print("recieved items in drink from mixer, timer started")
	can_transfer = false  # Disable transfer until cooldown ends
	$Timer.start()  # Start cooldown timer
	ingredients = list_data
	for ingredient in ingredients:
		$Label.text += ingredient + "\n"
		
func update_insides():
	$Label.text += ingredients[-1] + "\n"

func clear_insides():
	$Label.text = glass_name + "\n"
	
func _on_area_2d_mouse_entered():
	$Label.show()



func _on_area_2d_mouse_exited():
	$Label.hide()

func add_ingredient(ingredient):
	ingredients.append(ingredient)
	update_insides()
