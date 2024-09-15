extends Node2D

var ingredients = []
var shakeable = false
var time = 0
var shakes = 0
var last_velocity: Vector2 = Vector2(0,0)
var last_position: Vector2 = Vector2(0,0)
var is_dragging = false
var mixer_transfer = false
var place
var drink

signal send_mixer(ingredient_list)

# Called when the node enters the scene tree for the first time.
func _ready():
	place = position
	$Label.text = "Shaker \n"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position()
	if shakeable and "Shaken" not in ingredients:
		time += delta
		var velocity = (global_position - last_position) / delta
		var tmp1 = (last_velocity.x * last_velocity.y)
		var tmp2 = (velocity.x * velocity.y)
		if tmp1 > 0 and tmp2 < 0 or tmp2 > 0 and tmp1 < 0:
			print("shaking...", shakes)
			shakes += 1
			if shakes > 7:
				print("shook")
				ingredients.insert(0, "Shaken")
				var text = $Label.text
				$Label.text = "Shaken \n" + text
				shakeable = false
		last_velocity = velocity
		last_position = global_position
		if time > 10:
			time = 0
			if shakes >0:
				shakes -= 1


func _on_area_2d_area_entered(area):
	drink = area.get_parent()
	if drink and drink.name == "Drink":
		mixer_transfer = true
		if not drink.is_connected("send_mixer", Callable(self, "on_receive_list")) and drink.ingredients:
			drink.connect("send_mixer", Callable(self, "on_receive_list"))


func _on_area_2d_area_exited(area):
	if drink and drink.name == "Drink":
		mixer_transfer = false
		if drink.is_connected("send_mixer", Callable(self, "on_receive_list")) and drink.ingredients:
			drink.disconnect("send_mixer", Callable(self, "on_receive_list"))
		drink = null

func on_receive_list(list_data):
	print("recieved in mixer")
	ingredients += list_data
	shakeable = true
	for ingredient in list_data:
		$Label.text += ingredient + "\n" 
	
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("moving drink")
		if event.pressed:
			is_dragging = true
		else:
			if mixer_transfer and ingredients and drink.can_transfer and ((drink.ingredients and not ingredients) or (not drink.ingredients and ingredients)):
				print("TRANSFERING BACK")
				emit_signal("send_mixer", ingredients)
				ingredients = []
				clear_insides()
			is_dragging = false
			position = place

func clear_insides():
	$Label.text = "Shaker \n"
	
func _on_area_2d_mouse_entered():
	$Label.show()

func _on_area_2d_mouse_exited():
	$Label.hide()
