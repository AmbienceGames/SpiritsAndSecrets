extends Node2D

var recipe
var drink
var order
var total_price = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var curr_total_price = 0
	for child in get_parent().get_children():
		if child.name.begins_with("Ingredient") and child.has_label:
			curr_total_price += (child.count - child.curr_count) * child.price
	total_price = curr_total_price
	$CurrrentPrice.text = "Current Price of missing Ingredients: " + str(total_price) + " Gold!" + \
						"\nCurrent Gold: " + str(Globals.player_balance)
	if Globals.current_order != null:
		recipe = Globals.current_order
		$Order.text = recipe.generate_recipe_string()
		order = load("res://Scripts/order.gd").new()
		order.recipe = recipe
		
	if Globals.current_stars == 0 and order:
		for child in get_parent().get_children():
			if child.name == "Drink":
				drink = child
				break
		if drink and is_instance_valid(drink):
			var points = max(min(order.compare_to(drink), 1), 0)
			print(points)
			Globals.current_stars = int(points * 5)
			$Stars.text = "Drink Current Stars: " + str(Globals.current_stars)

func _on_refill_pressed():			
	if total_price <= Globals.player_balance:
		Globals.player_balance -= total_price
		for child in get_parent().get_children():
			if child.name.begins_with("Ingredient") and child.has_label:
				child.curr_count = child.count
				child.set_label()
		$Warning.text = "You spent " + str(total_price) + " Gold to refill your ingredients!"
	else:
		$Warning.text = "You don't have enough money, complete some orders first!"

func _on_submit_drink_button_down():
	for child in get_parent().get_children():
		if child.name == "Drink":
			drink = child
			break
	var points = order.compare_to(drink)
	var money_made = int(max(points * 4 * recipe.ingredients.size(), 0))
	$Warning.text = "You made " + str(money_made) + " Gold!\nGrab a new order."
	$Order.text = ""
	$Stars.text = ""
	Globals.player_balance += money_made
	recipe = null
	order = null
	Globals.current_order = null
	drink.queue_free()
	drink = null
