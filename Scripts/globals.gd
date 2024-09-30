extends Node


var day: int = 1
var time: float = 0.0
var paused = false

var cast: Array = [
	["trent","glanthor","constantine", "klaus","theo","lucius","lilianne","ethred"],
	["glanthor", "klaus","theo","lucius","lilianne","ethred"],
	["trent","glanthor","klaus","theo","lucius","lilianne","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
	["trent","glanthor","klaus","theo","lucius","ethred","traveler"],
]

var player_balance = 100

var ingredient_flavors = {
	"Dwarven Stout": ["strong", "alcoholic", "liquid", "dark"],
	"Elderflower Liqueur": ["light", "alcoholic", "liquid", "floral"],
	"Elven Moonshine": ["strong", "alcoholic", "liquid", "smooth"],
	"Halflings Whiskey": ["smooth", "alcoholic", "liquid", "caramel"],
	"Pirates Dark Rum": ["strong", "alcoholic", "liquid", "dark", "caramel"],
	"Dragonfruit Extract": ["sweet", "liquid", "colorful"],
	"Elven Honey": ["sweet", "liquid", "floral"],
	"Feywild Berry Juice": ["fruity", "liquid", "magical"],
	"Shadowroot Syrup": ["sweet", "liquid", "dark", "earthy"],
	"Celestial Citrus Blend": ["citrus", "liquid", "bright"],
	"Gnomish Ginger Brew": ["spicy", "liquid", "refreshing"],
	"Halflings Apple Cider": ["sweet", "liquid", "fruity"],
	"Moonlit Lavender Essence": ["floral", "liquid", "aromatic"],
	"Treant Sap": ["sweet", "liquid", "earthy"],
	"Rune Infused Rose Water": ["floral", "liquid", "magical"],
	"Ghost Pepper Elixir": ["spicy", "liquid", "bold"],
	"Goblin Spice": ["spicy", "solid", "bold", "powder"],
	"Mystic Mint Leaves": ["refreshing", "solid", "mint"],
	"Orcish Blood Orange Zest": ["tart", "solid", "citrus"],
	"Wizards Basil": ["aromatic", "solid", "herb"],
	"Pixie Dust Sugar": ["sweet", "solid", "colorful", "powder"],
	"Infernal Cinnamon Sticks": ["spicy", "solid", "warm"],
	"Elemental Ice Shards": ["cold", "solid", "magical"],
	"Mermaids Sea Salt": ["salty", "solid", "powder"],
	"Phoenix Feathers": ["bright", "solid", "bold"],
	"Sylvan Sage": ["aromatic", "solid", "herb"],
	"Thieves Blackberries": ["tart", "solid", "fruity"]
}

var favorite_recipes = {
	"constantine" : [
		"Dragon’s Breath", 
		"Honey Blossom", 
		"Pixie’s Delight", 
		"Enchanted Berry", 
		"Midnight Berry Bliss"
	],
	"ethred" : [
		"Dragon’s Breath", 
		"Fire and Ice", 
		"Thick Thadrick", 
		"Small Guys Only", 
		"Halfling's Apple Whiskey Surprise"
	],
	"glanthor" : [
		"Spiced Stout", 
		"Treant’s Whisper", 
		"Frosty Fruit Fizz", 
		"Sea of Blood", 
		"Pixie’s Delight"
	],
	"klaus" : [
		"Shadow Over The Sun", 
		"Celestial Sparkle", 
		"Thick Thadrick", 
		"Citrus Breeze", 
		"Treant’s Whisper"
	],
	"lilianne" : [
		"Celestial Sparkle", 
		"Honey Blossom", 
		"Citrus Breeze", 
		"Small Guys Only", 
		"Shadow Over The Sun"
	],
	"lucius" : [
		"Caramel Spiced Rum", 
		"Midnight Berry Bliss", 
		"Enchanted Berry", 
		"Revivification Needed", 
		"Honey Blossom"
	],
	"theo" : [
		"Shadow Over The Sun", 
		"Treant’s Whisper", 
		"Fire and Ice", 
		"Citrus Breeze", 
		"Frosty Fruit Fizz"
	],
	"traveler" : [
		"Revivification Needed", 
		"Halfling's Apple Whiskey Surprise", 
		"Caramel Spiced Rum", 
		"Sea of Blood", 
		"Dragon’s Breath"
	],
	"trent" : [
		"Sea of Blood", 
		"Spiced Stout", 
		"Revivification Needed", 
		"Small Guys Only", 
		"Fire and Ice"
	]
};

var patron_orders_info = {
	"Constantine" : ["Default", 0, 0],
	"Ethred" : ["Default", 0, 0],
	"Glanthor" : ["Default", 0, 0],
	"Klaus" : ["Default", 0, 0],
	"Lilianne" : ["Default", 0, 0],
	"Lucius" : ["Default", 0, 0],
	"Theo" : ["Default", 0, 0],
	"Traveler" : ["Default", 0, 0],
	"Trent" : ["Default", 0, 0]
};

var special_ingredients = ["Shaken", "Stirred", "Ice", "Soda Water", "Dwarven Stout", "Elderflower Liqueur", "Elven Moonshine", "Halflings Whiskey", "Pirates Dark Rum"]
var unlocked_ingredients = []
var recipes = []
var current_order = null
var viable_recipes = []
var viable_check = false
var pinning = null
var person_waiting = false
var clues_updated = false
var top_clue = false
			
func get_cast_for_day() -> Array[PackedScene]:
	var names = cast[day-1]
	var path = "res://Scenes/Characters"
	var dir = DirAccess.open(path)
	var res: Array[PackedScene] = []
	for name in names:
		var patron = load(path + "/" + name + ".tscn")
		res.append(patron)
	return res


func load_json_file(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()  # Create an instance of the JSON class
	var json_error = json.parse(json_string)
	
	if json_error != OK:
		print("Failed to parse JSON, error code: ", json_error)
		return {}
	
	var json_result = json.get_data()  # Extract the parsed data
	return json_result

# Function to turn JSON into recipe objects
func create_recipes_from_json(json_data: Dictionary) -> Array:
	var recipes_list = []
	var recipes_data = json_data.get("recipes", [])
	
	for recipe_data in recipes_data:
		var new_recipe = Recipe.new()
		new_recipe.recipe_name = recipe_data.get("recipe_name", "")
		new_recipe.glass_type = recipe_data.get("glass_type", "")
		new_recipe.ingredients = recipe_data.get("ingredients", [])
		new_recipe.has_ice = recipe_data.get("has_ice", false)
		
		recipes_list.append(new_recipe)
	
	return recipes_list
	
func get_patron_order(patron_name):
	var valid_recipes = []
	for item in favorite_recipes[patron_name.to_lower()]:
		if item in viable_recipes:
			valid_recipes.append(item)
	patron_orders_info[patron_name][0] = valid_recipes[(randi_range(0, valid_recipes.size()-1))]

# Called when the node enters the scene tree for the first time.
func _ready():
	var json_data = load_json_file("res://Recipes/recipes.json")
	recipes = create_recipes_from_json(json_data)
	
	for recipe in recipes:
		print(recipe.generate_recipe_string())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not paused:
		time += delta
	if not viable_check:
		for single_recipe in recipes:
			var check = false
			for single_ingredient in single_recipe.ingredients:
				if single_ingredient not in Globals.unlocked_ingredients and single_ingredient not in Globals.special_ingredients:
					check = true
					break
			if not check:
				viable_recipes.append(single_recipe.recipe_name)
		viable_check = true


