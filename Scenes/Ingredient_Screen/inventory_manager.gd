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
	
func _on_new_order_pressed():
	var viable_recipes = []
	for single_recipe in Globals.recipes:
		var check = false
		for single_ingredient in single_recipe.ingredients:
			print(single_ingredient)
			if single_ingredient not in Globals.unlocked_ingredients and single_ingredient not in Globals.special_ingredients:
				check = true
				break
		if not check:
			viable_recipes.append(single_recipe)
	print(viable_recipes)
	recipe = viable_recipes[(randi_range(0, viable_recipes.size()-1))]
	
	$Order.text = recipe.generate_recipe_string()
	order = load("res://Scripts/order.gd").new()
	order.recipe = recipe

func _on_submit_drink_button_down():
	for child in get_parent().get_children():
		if child.name == "Drink":
			drink = child
			break
	var points = order.compare_to(drink)
	var money_made = max(points * 10 * recipe.ingredients.size(), 0)
	$Warning.text = "You made " + str(money_made) + " Gold!\nGrab a new order."
	Globals.player_balance += money_made
	recipe = null
	order = null
	drink.queue_free()
